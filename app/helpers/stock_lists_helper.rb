require 'pycall/import'
include PyCall::Import
module StockListsHelper

  def jq_http_request(data)
    uri = URI.parse("https://dataapi.joinquant.com/apis")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    req.body = data
    res = https.request(req)
    return res.body
  end

  def jq_auth_http
    body = {
        "method" => "get_token",
        "mob" => ENV['jq_data_username'],
        "pwd" => ENV['jq_data_password']
    }.to_json
    token = ApplicationController.helpers.jq_http_request(body)
    return token
  end

  def normalize_code_jq(stock_code)
    jq_stock_code = false
    stock_list = StockList.find_by(stock_code: stock_code)
    if stock_list
      jq_stock_code =
      case stock_list.market_code
      when "sh"
        ".XSHG"
      when "sz"
        ".XSHE"
      end
    end
    return jq_stock_code
  end

  def jq_from_date(duration, row)
    current_time = Time.now - 1.minute
    end_date = current_time.strftime("%Y-%m-%d %H:%M:%S")
    date =
    case duration
    when '1d'
      (current_time - row.days).strftime("%Y-%m-%d %H:%M:%S")
    when '1m'
      if (current_time < "9:30".to_time || current_time > "15:03".to_time)
        if current_time > "00:00".to_time
          ((current_time - 1.days).change({ hour: 15, min: 0, sec: 0 }) - row.minutes).strftime("%Y-%m-%d %H:%M:%S")
        else
          (current_time.change({ hour: 15, min: 0, sec: 0 }) - row.minutes).strftime("%Y-%m-%d %H:%M:%S")
        end
      elsif (current_time > "11:30".to_time && current_time < "13:00".to_time)
        (current_time.change({ hour: 11, min: 30, sec: 0 }) - row.minutes).strftime("%Y-%m-%d %H:%M:%S")
      else
        (current_time - row.minutes).strftime("%Y-%m-%d %H:%M:%S")
      end
    end

    return date, end_date
  end

  def jq_data_bar_http(stock_code, duration, row)
    stock_code = stock_code + ApplicationController.helpers.normalize_code_jq(stock_code)
    date, end_date = ApplicationController.helpers.jq_from_date(duration, row)
    token = ApplicationController.helpers.jq_auth_http
    body = {
        "method" => "get_bars_period",
        "token" => token,
        "code" => stock_code,
        "unit" => duration,
        "date" => date,
        "end_date" => end_date,
        "fq_ref_date" => ""
    }.to_json
    data = ApplicationController.helpers.jq_http_request(body)
    return data
  end

  def jq_index_stocks_http(stock_code)
    token = ApplicationController.helpers.jq_auth_http
    body = {
        "method" => "get_index_stocks",
        "token" => token,
        "code" => stock_code,
        "date" => Date.today.strftime('%Y-%m-%d')
    }.to_json
    data = ApplicationController.helpers.jq_http_request(body)
    return data
  end

  def jq_auth
    pyimport 'jqdatasdk'
    jqdatasdk.auth(ENV['jq_data_username'], ENV['jq_data_password'])
  end

  def jq_data(stock_code, duration, row)
    # security = '513500.XSHG'
    # duration = '1m'
    ApplicationController.helpers.jq_auth
    begin
      security = jqdatasdk.normalize_code(stock_code)
      data = jqdatasdk.get_bars(security, row, unit="#{duration}",fields=['date', 'open', 'high', 'low', 'close','volume', 'money'],include_now=false)
    rescue Exception => e
      data = false
      Rails.logger.warn "data_to_csv failed: #{e}"
    ensure
      jqdatasdk.logout()
    end
    return data
  end

  def csv_row_check(stock_code, duration)
    flag = false
    file = Rails.root.to_s + "/tmp/data/#{stock_code}_#{duration}.csv"
    if File.exist?(file)
      table = CSV.parse(File.read(file), headers: true)
      flag = true if table.count >= 10
    end
    return flag
  end

  def data_to_csv(data, stock_code, duration, is_tmp = true)
    if is_tmp
      file = Rails.root.to_s + "/tmp/data/tmp/#{stock_code}_#{duration}_tmp.csv"
    else
      file = Rails.root.to_s + "/tmp/data/#{stock_code}_#{duration}.csv"
    end

    begin
      if data.class == Object
        data.to_csv(path_or_buf: "#{file}", index: false)
      else
        File.open(file, 'w') do |f|
          f.write(data)
        end
      end
    rescue Exception => e
      file = false
      Rails.logger.warn "data_to_csv failed: #{e}"
    end
    return file
  end

  def merge_csv(stock_code, duration)
    file = Rails.root.to_s + "/tmp/data/#{stock_code}_#{duration}.csv"
    tmp_file = Rails.root.to_s + "/tmp/data/tmp/#{stock_code}_#{duration}_tmp.csv"
    table = CSV.parse(File.read(file), headers: true)
    tmp_table = CSV.parse(File.read(tmp_file), headers: true)
    last_date = table[-1]["date"]
    tmp_table.delete_if do |row|
      row["date"].to_time <= last_date.to_time
    end
    tmp_table.each do |row|
      table.push(row)
    end
    File.open(file, 'w') do |f|
      f.write(table.to_csv)
    end
    return file
  end

  def tushare_auth
    pyimport 'tushare', as: :ts
    ts.set_token(ENV['tushare_token'])
    pro = ts.pro_api()
    # df = pro.query('trade_cal', exchange: '', start_date: '20200101', end_date: '20201231', fields: 'exchange,cal_date,is_open,pretrade_date', is_open: '0')
    return ts, pro
  end

  def tushare_stock_list
    array = []
    url = "http://api.waditu.com"
    res = HTTParty.post(url,
          headers: {"Content-Type" => "application/json"},
          body: {:api_name => "stock_basic", :token=> ENV['tushare_token'], :params=> {}}.to_json)
    if res.code == 200
      json = JSON.parse(res.body)
      array = json["data"]["items"]
    end
    return array
  end

  # 名称	类型	必选	描述
  # ts_code	str	Y	证券代码
  # api	str	N	pro版api对象，如果初始化了set_token，此参数可以不需要
  # start_date	str	N	开始日期 (格式：YYYYMMDD，提取分钟数据请用2019-09-01 09:00:00这种格式)
  # end_date	str	N	结束日期 (格式：YYYYMMDD)
  # asset	str	Y	资产类别：E股票 I沪深指数 C数字货币 FT期货 FD基金 O期权 CB可转债（v1.2.39），默认E
  # adj	str	N	复权类型(只针对股票)：None未复权 qfq前复权 hfq后复权 , 默认None
  # freq	str	Y	数据频度 ：支持分钟(min)/日(D)/周(W)/月(M)K线，其中1min表示1分钟（类推1/5/15/30/60分钟） ，默认D。对于分钟数据有600积分用户可以试用（请求2次），正式权限请在QQ群私信群主或积分管理员。
  # ma	list	N	均线，支持任意合理int数值。注：均线是动态计算，要设置一定时间范围才能获得相应的均线，比如5日均线，开始和结束日期参数跨度必须要超过5日。目前只支持单一个股票提取均线，即需要输入ts_code参数。
  # factors	list	N	股票因子（asset='E'有效）支持 tor换手率 vr量比
  # adjfactor	str	N	复权因子，在复权数据时，如果此参数为True，返回的数据中则带复权因子，默认为False。 该功能从1.2.33版本开始生效
  def tushare_bar(ts, pro)
    security = '600000.sh'
    df = ts.pro_bar(ts_code: security, start_date: '2021-07-07 09:00:00', end_date: '2021-07-09 15:00:00', freq: '1min')
    fields = ['trade_time', 'open', 'high', 'low', 'close', 'vol', 'amount']
  end

  def get_all_stock_list
    array = ApplicationController.helpers.tushare_stock_list
    array.each do |stock|
      begin
        new_stock = StockList.find_or_initialize_by(stock_code: stock[1])
        a = PinYin.of_string(stock[2], :ascii)
        py = ""
        a.map{|x| py = py + x[0].upcase}

        new_stock.stock_name = py
        new_stock.stock_display_name = stock[2]
        new_stock.market_code = stock[0][7..8].downcase
        new_stock.market = (stock[0][7..8].downcase == "sz" ? "深A" : "沪A")

        new_stock.save!
        # p new_stock
      rescue ExceptionName
        Rails.logger.warn "get_all_stock_list error: #{e.message}"
        next
      end
    end

    # pyimport 'easyquotation'
    # quotation = easyquotation.use('tencent')
    # h = quotation.market_snapshot(prefix='True')
    # h.each do |stock|
    #   begin
    #     new_stock = StockList.find_or_initialize_by(stock_code: stock[0][2..7])
    #     a = PinYin.of_string(stock[1]['name'], :ascii)
    #     py = ""
    #     a.map{|x| py = py + x[0].upcase}
    #
    #     new_stock.stock_name = py
    #     new_stock.stock_display_name = stock[1]['name']
    #     new_stock.market_code = stock[0][0..1]
    #     new_stock.market = (stock[0][0..1] == "sz" ? "深A" : "沪A")
    #
    #     new_stock.save!
    #     p new_stock
    #   rescue Exception => e
    #     Rails.logger.warn "get_all_stock_list error: #{e.message}"
    #     next
    #   end
    # end
  end

end

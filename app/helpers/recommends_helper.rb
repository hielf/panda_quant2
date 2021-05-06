module RecommendsHelper

  def get_stock_price(recommends)
    a = []
    recommends.each do |r|
      a << stock_code_trans(r.stock_code[0..5])
    end
    stock_codes = a.join(",")
    unless stock_codes.empty?
      url = "http://hq.sinajs.cn/list=#{stock_codes}"
      res = HTTParty.get url
      res.body.split(';').each.with_index(0) do |stock, index|
        data = CGI::unescape(stock.gsub("var ", "").gsub("hq_str_", "").gsub("\n", "").gsub("\"", "")).encode('utf-8','gbk',{:invalid => :replace, :undef => :replace, :replace => '?'}).split(',')
        unless data.empty?
          open_price = data[1]
          current_price = data[3]
          p [index, open_price, current_price]
          recommends[index].update(open_price: open_price, current_price: current_price)
          if recommends[index].recommend_date == Date.today
            recommends[index].update(recommend_price: open_price)
          end
        end
      end
    end
  end

  def stock_code_trans(code)
    case code[0]
    when "6"
      "sh" + code
    else
      "sz" + code
    end
  end
end

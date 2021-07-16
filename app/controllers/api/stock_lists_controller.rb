class Api::StockListsController < Api::ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :market_quotations, :stock_analysis_results]

  def stock_analysis_results
    m_requires! [:id]
    stock_analyse = StockAnalyse.find(params[:id])
    @result = stock_analyse

    render_json([0, '获取成功', @result])
  end

  def market_quotations
    m_requires! [:stock_code, :duration, :start_time, :length]

    # { time: {year: 2018, month: 12, day: 19} , open: 69.97765183896102 , high: 69.97765183896102 , low: 58.73355952507237 , close: 58.73355952507237 }

    @result = []
    stock_code = params[:stock_code]
    duration = params[:duration]
    start_time = params[:start_time]
    length = params[:length].to_i
    file = Rails.root.to_s + "/tmp/data/#{stock_code}_#{duration}.csv"
    array = CSV.parse(File.read(file), headers: true).map {|row| row.to_h }
    count = 0

    before = 3.minutes
    if start_time.to_time.hour == 0
      before = 3.days
    end

    array.each do |hash|
      if "#{hash['date']}+08:00".to_datetime >= start_time.to_datetime - before
        if duration == "1d"
          @result << {"time": {"year":hash['date'].to_datetime.strftime('%Y'),
                      "month":hash['date'].to_datetime.strftime('%m'),
                      "day":hash['date'].to_datetime.strftime('%d')},
                      "open":hash["open"],
                      "high":hash["high"],
                      "low":hash["low"],
                      "close":hash["close"]}
        elsif duration == "1m"
          p "#{hash['date']}+08:00".to_datetime
          @result << {"time":hash['date'].to_datetime.to_i,
                      "open":hash["open"],
                      "high":hash["high"],
                      "low":hash["low"],
                      "close":hash["close"]}
        end

        count = count + 1
      end
      break if count >= length
    end

    render_json([0, '获取成功', @result])
  end

  def index
    if !params[:query_type].nil? && params[:query_type] == "all"
      @stock_list = StockList.all
    else
      m_requires! [:char]
      char = params[:char]
      ids = []
      stock_list = StockList.where("stock_code LIKE '%#{char}%'  OR stock_name LIKE '%#{char}%'  OR stock_display_name LIKE '%#{char}%'").limit(12)
      stock_list.each do |stock|
        if stock.stock_reports.empty?
          ids << stock.id
        end
      end
      @stock_list = stock_list.where.not(id: ids)
    end

    render 'index'
  end

  def user_history
    @user_history = current_user.stock_lists.last(9)

    render 'user_history'
  end

end

class Api::StockListsController < Api::ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :market_quotations]

  def market_quotations
    m_requires! [:stock_code, :duration, :start_time, :length]

    @result = []
    stock_code = params[:stock_code]
    duration = params[:duration]
    start_time = params[:start_time]
    length = params[:length].to_i
    file = Rails.root.to_s + "/tmp/data/#{stock_code}_#{duration}.csv"
    array = CSV.parse(File.read(file), headers: true).map {|row| row.to_h }
    count = 0
    array.each do |hash|
      if hash["date"] >= start_time
        @result << hash
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

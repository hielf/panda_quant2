class Api::StockListsController < Api::ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

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

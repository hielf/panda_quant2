json.status 0
json.message '获取成功'

json.data do
  json.paginate_attrs do
    paginate_attrs(json, @recommends)
  end
  json.recommends do
    json.array! (@today).downto(@date) do |d|
      json.recommend_date d
      @recommends.group_by{ |c| c.recommend_date }.each do |re|
        json.stocks do
          if re[0] == d
            json.array! re[1] do |stock|
              json.stock_name stock.stock_name
              json.stock_code stock.stock_code
              json.note stock.note
              json.created_at strftime_time(stock.created_at)
              json.updated_at strftime_time(stock.updated_at)

              json.column_0 "涨跌幅"
              json.value_0 quote_change(stock.open_price, stock.current_price)
              json.column_1 "推荐时价"
              json.value_1 stock.recommend_price.nil? ? "-" : stock.recommend_price.to_s
              json.column_2 "开盘价"
              json.value_2 stock.open_price.nil? ? "-" : stock.open_price.to_s
              json.column_3 "当前价"
              json.value_3 stock.current_price.nil? ? "-" : stock.current_price.to_s
              json.img_url "http://image.sinajs.cn/newchart/min/n/#{stock_code_trans(stock.stock_code[0..5])}.gif"
            end
          else
            json.array! do
              
            end
          end
        end
      end
    end


    # json.array! @recommends.group_by{ |c| c.recommend_date } do |re|
    #   json.recommend_date re[0]
    #   json.stocks do
    #     json.array! re[1] do |stock|
    #       json.stock_name stock.stock_name
    #       json.stock_code stock.stock_code
    #       json.note stock.note
    #       json.created_at strftime_time(stock.created_at)
    #       json.updated_at strftime_time(stock.updated_at)
    #
    #       json.column_0 "涨跌幅"
    #       json.value_0 quote_change(stock.open_price, stock.current_price)
    #       json.column_1 "推荐时价"
    #       json.value_1 stock.recommend_price.nil? ? "-" : stock.recommend_price.to_s
    #       json.column_2 "开盘价"
    #       json.value_2 stock.open_price.nil? ? "-" : stock.open_price.to_s
    #       json.column_3 "当前价"
    #       json.value_3 stock.current_price.nil? ? "-" : stock.current_price.to_s
    #       json.img_url "http://image.sinajs.cn/newchart/min/n/#{stock_code_trans(stock.stock_code[0..5])}.gif"
    #     end
    #   end
    # end

  end
end

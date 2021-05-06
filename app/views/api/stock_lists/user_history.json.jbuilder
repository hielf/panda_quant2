json.status 0
json.message '获取成功'

json.data do
  json.history do
    json.array! @user_history do |stock_list|
      json.stock_list_id stock_list.id
      json.stock_code stock_list.stock_code
      json.stock_display_name stock_list.stock_display_name
      json.market stock_list.market
    end
  end
end

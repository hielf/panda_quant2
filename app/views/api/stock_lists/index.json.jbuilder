json.status 0
json.message '获取成功'

json.data do
  json.packages do
    json.array! @stock_list do |stock|
      json.stock_list_id stock.id
      json.code stock.stock_code
      json.name stock.stock_display_name
      json.market stock.market
    end
  end
end

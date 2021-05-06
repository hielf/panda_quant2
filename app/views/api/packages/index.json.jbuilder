json.status 0
json.message '获取成功'

json.data do
  json.packages do
    json.array! @packages do |package|
      json.id package.id
      json.title package.title
      json.period package.period
      json.market_price package.market_price.to_i
      json.discount package.discount
      json.real_price package.real_price.to_i
      json.package_type package.package_type
      json.desc package.desc
    end
  end
end

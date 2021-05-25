# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Package.find_or_create_by(title: "包月套餐", period: "月", date_num: 30, market_price: 0.01, discount: 1, real_price: 0.01*1, package_type: "基础套餐", desc: "可关注2个代码", watch_num: 2)
Package.find_or_create_by(title: "半年套餐", period: "半年", date_num: 180, market_price: 100, discount: 0.9, real_price: 100*0.9, package_type: "基础套餐", desc: "可关注10个代码", watch_num: 10)
Package.find_or_create_by(title: "包年套餐", period: "一年", date_num: 365, market_price: 200, discount: 0.75, real_price: 200*0.9, package_type: "基础套餐", desc: "可关注10个代码", watch_num: 10)
Package.find_or_create_by(title: "包月套餐", period: "月", date_num: 30, market_price: 90, discount: 1, real_price: 90*1, package_type: "高级套餐", desc: "可关注50个代码", watch_num: 50)
Package.find_or_create_by(title: "半年套餐", period: "半年", date_num: 180, market_price: 500, discount: 0.9, real_price: 500*0.9, package_type: "高级套餐", desc: "可关注50个代码", watch_num: 50)
Package.find_or_create_by(title: "包年套餐", period: "一年", date_num: 365, market_price: 1000, discount: 0.75, real_price: 1000*0.75, package_type: "高级套餐", desc: "可关注50个代码", watch_num: 50)

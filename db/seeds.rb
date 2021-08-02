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

Package.find_or_create_by(title: "包月基础套餐", period: "月", date_num: 30, market_price: 10, discount: 0.001, real_price: 10*0.001, package_type: "基础套餐", desc: "可关注2个代码，日线级别提醒", watch_num: 2)
Package.find_or_create_by(title: "半年基础套餐", period: "半年", date_num: 180, market_price: 100, discount: 0.9, real_price: 100*0.9, package_type: "基础套餐", desc: "可关注10个代码，日线级别提醒", watch_num: 10)
Package.find_or_create_by(title: "包年基础套餐", period: "一年", date_num: 365, market_price: 200, discount: 0.75, real_price: 200*0.9, package_type: "基础套餐", desc: "可关注10个代码，日线级别提醒", watch_num: 10)
Package.find_or_create_by(title: "包月高级套餐", period: "月", date_num: 30, market_price: 90, discount: 1, real_price: 90*1, package_type: "高级套餐", desc: "可关注50个代码，日线、分钟线级别提醒", watch_num: 50)
Package.find_or_create_by(title: "半年高级套餐", period: "半年", date_num: 180, market_price: 500, discount: 0.9, real_price: 500*0.9, package_type: "高级套餐", desc: "可关注50个代码，日线、分钟线级别提醒", watch_num: 50)
Package.find_or_create_by(title: "包年高级套餐", period: "一年", date_num: 365, market_price: 1000, discount: 0.75, real_price: 1000*0.75, package_type: "高级套餐", desc: "可关注50个代码，日线、分钟线级别提醒", watch_num: 50)
Package.find_or_create_by(title: "新用户大礼包", period: "天", date_num: 7, market_price: 0, discount: 1, real_price: 0, package_type: "新手礼包", desc: "赠送精选成份指数股票日线级别提醒", watch_num: 0)

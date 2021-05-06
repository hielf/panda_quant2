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

Package.find_or_create_by(title: "包月套餐", period: "月", date_num: 30, market_price: 150, discount: 0.9, real_price: 150*0.9, package_type: "基础套餐", desc: "熊猫宽课AI推荐股票30天")
Package.find_or_create_by(title: "半年套餐", period: "半年", date_num: 180, market_price: 800, discount: 0.9, real_price: 800*0.9, package_type: "基础套餐", desc: "熊猫宽课AI推荐股票180天")
Package.find_or_create_by(title: "整年套餐", period: "一年", date_num: 365, market_price: 1500, discount: 0.9, real_price: 1500*0.9, package_type: "基础套餐", desc: "熊猫宽课AI推荐股票365天")

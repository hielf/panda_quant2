namespace :recommend do
  task :quotes => :environment do
    include RecommendsHelper

    recommends = Recommend.where("recommend_date >= ?", Date.today - 3)
    get_stock_price(recommends)

  end
end

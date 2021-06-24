module MarketShapeHelper
  # ApplicationController.helpers.find_w
  def find_w(stock_code, duration)
    # python find_w.py 110044.SH 1min 2 -0.005 0 3 2 -0.001

    close_desceding_x = 2 #rand(1..5)
    close_desceding_rate_x = -0.005 #rand(-0.06..-0.005)
    amount_desceding_x = 2 #rand(1..5)#连续交易量下跌次数
    amount_rising_count_bp = 1 #rand(0..3) #突破连续成交量放大次数
    close_rising_count_s = 2 #买入连续冲高次数
    close_rising_rate_s = -0.001 #冲高回落跌幅

    json = "#{Rails.root.to_s}/tmp/result/result_#{duration}_#{stock_code}.json"
    data_path = "#{Rails.root.to_s}/tmp/data/#{stock_code}_#{duration}.csv"
    system( "cd #{Rails.root.to_s + '/lib/python/market_shape'} && python3 find_w.py #{stock_code} #{duration} #{close_desceding_x} #{close_desceding_rate_x} #{amount_desceding_x} #{amount_rising_count_bp} #{close_rising_count_s} #{close_rising_rate_s} #{json} #{data_path}" )
    data = JSON.parse(File.read(json))
    data.each do |sa|
      StockAnalysis.create(stock_code: sa["stock_code"],
        duration: sa["duration"],
        params: sa["params"],
        results: sa["results"],
        profit_ratio: sa["profit_ratio"],
        begin_time: sa["begin_time"],
        end_time: sa["end_time"])
    end
  end

  def results_to_csv
    s=CSV.generate do |csv|
      hashes = []
      StockAnalysis.all.each do |sa|
        hash = {}
        hash["stock_code"] = sa.stock_code
        hash["duration"] = sa.duration
        hash["profit_ratio"] = sa.profit_ratio
        hash.merge!(eval(sa.params))
        hashes << hash
      end

      column_names = hashes.first.keys
      s=CSV.generate do |csv|
        csv << column_names
        hashes.each do |x|
          csv << x.values
        end
      end
      File.write('results.csv', s)
    end
  end

end

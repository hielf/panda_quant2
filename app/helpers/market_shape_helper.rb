module MarketShapeHelper
  # ApplicationController.helpers.find_w
  def find_w
    # "113521.SH", "132022.SH",
    assetList = ["110031.SH","110033.SH","110034.SH","110038.SH","110041.SH","110042.SH","110043.SH","110044.SH","110045.SH","110047.SH","110048.SH","110051.SH","110052.SH","110053.SH","110055.SH","110056.SH","110057.SH","110058.SH","110059.SH","110060.SH","110061.SH","110062.SH","110063.SH","110064.SH","110065.SH","110066.SH","110067.SH","110068.SH","110069.SH","110070.SH","110071.SH","113008.SH","113009.SH","113011.SH","113012.SH","113013.SH","113014.SH","113016.SH","113017.SH","113019.SH","113020.SH","113021.SH","113022.SH","113024.SH","113025.SH","113026.SH","113027.SH","113028.SH","113029.SH","113030.SH","113031.SH","113032.SH","113033.SH","113034.SH","113035.SH","113036.SH","113502.SH","113504.SH","113505.SH","113508.SH","113509.SH","113514.SH","113516.SH","113518.SH","113519.SH","113520.SH","113524.SH","113525.SH","113526.SH","113527.SH","113528.SH","113530.SH","113532.SH","113534.SH","113535.SH","113536.SH","113537.SH","113541.SH","113542.SH","113543.SH","113544.SH","113545.SH","113546.SH","113547.SH","113548.SH","113549.SH","113550.SH","113551.SH","113552.SH","113553.SH","113554.SH","113555.SH","113556.SH","113557.SH","113558.SH","113559.SH","113561.SH","113562.SH","113563.SH","113564.SH","113565.SH","113566.SH","113567.SH","113568.SH","113569.SH","113570.SH","113571.SH","113572.SH","113573.SH","113574.SH","113575.SH","113576.SH","113577.SH","113578.SH","113579.SH","113580.SH","113581.SH","113582.SH","113583.SH","113584.SH","113585.SH","113586.SH","113587.SH","113588.SH","113589.SH","113590.SH","113591.SH","113592.SH","117037.SZ","117048.SZ","117058.SZ","117091.SZ","117094.SZ","117095.SZ","117096.SZ","117103.SZ","117107.SZ","117108.SZ","117109.SZ","117111.SZ","117115.SZ","117118.SZ","117120.SZ","117125.SZ","117127.SZ","117131.SZ","117132.SZ","117133.SZ","117135.SZ","117136.SZ","117137.SZ","117138.SZ","117140.SZ","117142.SZ","117144.SZ","117145.SZ","117146.SZ","117147.SZ","117148.SZ","117150.SZ","117152.SZ","117153.SZ","117154.SZ","117155.SZ","117156.SZ","117157.SZ","117158.SZ","117159.SZ","117160.SZ","117161.SZ","117162.SZ","117163.SZ","117164.SZ","117165.SZ","120002.SZ","120003.SZ","120004.SZ","123002.SZ","123004.SZ","123007.SZ","123010.SZ","123011.SZ","123012.SZ","123013.SZ","123014.SZ","123015.SZ","123017.SZ","123018.SZ","123020.SZ","123022.SZ","123023.SZ","123024.SZ","123025.SZ","123026.SZ","123027.SZ","123028.SZ","123029.SZ","123030.SZ","123031.SZ","123032.SZ","123033.SZ","123034.SZ","123035.SZ","123036.SZ","123037.SZ","123038.SZ","123039.SZ","123040.SZ","123041.SZ","123042.SZ","123043.SZ","123044.SZ","123045.SZ","123046.SZ","123047.SZ","123048.SZ","123049.SZ","123050.SZ","123051.SZ","123052.SZ","123053.SZ","123054.SZ","123055.SZ","123056.SZ","123057.SZ","124001.SZ","124002.SZ","124003.SZ","124004.SZ","124005.SZ","124006.SZ","124007.SZ","124008.SZ","124009.SZ","124011.SZ","124012.SZ","124013.SZ","127003.SZ","127004.SZ","127005.SZ","127006.SZ","127007.SZ","127008.SZ","127011.SZ","127012.SZ","127013.SZ","127014.SZ","127015.SZ","127016.SZ","127017.SZ","127018.SZ","128010.SZ","128012.SZ","128013.SZ","128014.SZ","128015.SZ","128017.SZ","128018.SZ","128019.SZ","128021.SZ","128022.SZ","128023.SZ","128025.SZ","128026.SZ","128028.SZ","128029.SZ","128030.SZ","128032.SZ","128033.SZ","128034.SZ","128035.SZ","128036.SZ","128037.SZ","128039.SZ","128040.SZ","128041.SZ","128042.SZ","128043.SZ","128044.SZ","128045.SZ","128046.SZ","128048.SZ","128049.SZ","128050.SZ","128051.SZ","128052.SZ","128053.SZ","128054.SZ","128056.SZ","128057.SZ","128058.SZ","128059.SZ","128062.SZ","128063.SZ","128064.SZ","128065.SZ","128066.SZ","128067.SZ","128069.SZ","128070.SZ","128071.SZ","128072.SZ","128073.SZ","128074.SZ","128075.SZ","128076.SZ","128077.SZ","128078.SZ","128079.SZ","128080.SZ","128081.SZ","128082.SZ","128083.SZ","128084.SZ","128085.SZ","128086.SZ","128087.SZ","128088.SZ","128089.SZ","128090.SZ","128091.SZ","128092.SZ","128093.SZ","128094.SZ","128095.SZ","128096.SZ","128097.SZ","128098.SZ","128099.SZ","128100.SZ","128101.SZ","128102.SZ","128103.SZ","128104.SZ","128105.SZ","128106.SZ","128107.SZ","128108.SZ","128109.SZ","128110.SZ","128111.SZ","128112.SZ","128113.SZ","128114.SZ","128115.SZ","128116.SZ","128117.SZ","128118.SZ","128119.SZ","132004.SH","132005.SH","132006.SH","132007.SH","132008.SH","132009.SH","132011.SH","132012.SH","132013.SH","132014.SH","132015.SH","132016.SH","132017.SH","132018.SH","132019.SH","132020.SH","132021.SH","137010.SH","137027.SH","137032.SH","137035.SH","137037.SH","137038.SH","137039.SH","137040.SH","137041.SH","137043.SH","137044.SH","137047.SH","137048.SH","137049.SH","137050.SH","137051.SH","137053.SH","137055.SH","137056.SH","137057.SH","137058.SH","137059.SH","137060.SH","137061.SH","137062.SH","137063.SH","137065.SH","137067.SH","137068.SH","137069.SH","137070.SH","137071.SH","137072.SH","137073.SH","137074.SH","137075.SH","137076.SH","137077.SH","137079.SH","137080.SH","137081.SH","137082.SH","137083.SH","137085.SH","137089.SH","137090.SH","137091.SH","137094.SH","137095.SH","137096.SH","137097.SH","137098.SH","137099.SH","137100.SH","137101.SH","137102.SH","137104.SH","137105.SH","137106.SH","137107.SH","137108.SH","137109.SH","137110.SH","137111.SH","137112.SH","137113.SH"]
    # python find_w.py 110044.SH 1min 2 -0.005 0 3 2 -0.001

    # stock_code = '110044.SH' #代码
    # duration = '1min' #周期 (1min  or  5min)
    # close_desceding_x = 2 #连续收盘下跌次数
    # close_desceding_rate_x = -0.005 #连续收盘下跌幅度
    # amount_desceding_x = 0 #连续交易量下跌次数
    # amount_rising_count_bp = 3 #突破连续成交量放大次数
    # close_rising_count_s = 2 #买入连续冲高次数
    # close_rising_rate_s = -0.001 #冲高回落跌幅

    assetList.each do |stock_code|
      ["1min", "5min"].each do |duration|
        # p [stock_code, duration]
        json = Rails.root.to_s + '/lib/python/market_shape/' + 'result.json'
        close_desceding_x = 2 #rand(1..5)
        close_desceding_rate_x = -0.01 #rand(-0.06..-0.005)
        amount_desceding_x = 0 #rand(1..5)#连续交易量下跌次数
        amount_rising_count_bp = 1 #rand(0..3) #突破连续成交量放大次数
        close_rising_count_s = rand(0..10) #买入连续冲高次数
        close_rising_rate_s = rand(-0.02..-0.001) #冲高回落跌幅
        system( "cd #{Rails.root.to_s + '/lib/python/market_shape'} && python3 find_w.py #{stock_code} #{duration} #{close_desceding_x} #{close_desceding_rate_x} #{amount_desceding_x} #{amount_rising_count_bp} #{close_rising_count_s} #{close_rising_rate_s}" )
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
    end;0

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
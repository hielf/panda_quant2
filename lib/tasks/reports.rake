namespace :stock do
  task :list => :environment do
    include StockReportsHelper

    get_all_stock_list

  end

  task :reports => :environment do
    include StockReportsHelper

    get_stock_reports

  end

  task :generate => :environment do
    include StockReportsHelper

    generate_report

  end
end

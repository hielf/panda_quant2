require 'clockwork'
# require 'clockwork/database_events'
require '../../config/boot'
require '../../config/environment'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)

module Clockwork
  # configure do |config|
  #   config[:sleep_timeout] = 5
  #   config[:logger] = Logger.new(log_file_path)
  #   config[:tz] = 'EST'
  #   config[:max_threads] = 15
  #   config[:thread] = true
  # end

  # handler receives the time when job is prepared to run in the 2nd argument
  handler do |job, time|
    if job == 'stock.list'
      Rails.logger.warn "stock.list start"
      ApplicationController.helpers.get_all_stock_list
      Rails.logger.warn "stock.list end"
    end

    if job == 'stock.quotations_min'
      current_time = Time.zone.now
      return if (current_time.saturday? || current_time.sunday?)
      return if (current_time > "12:00".to_time && current_time < "13:00".to_time)
      return if (current_time < "9:30".to_time || current_time > "15:03".to_time)
      sleep 3

      duration = '1m'
      stock_lists = UserStockListRel.watching_list_min.uniq

      stock_lists.each do |stock_list|
        stock_code = stock_list.stock_code
        StockAnalyseJob.perform_later stock_code, duration
      end
    end

    if job == 'stock.quotations_daily'
      current_time = Time.zone.now
      return if (current_time.saturday? || current_time.sunday?)
      return if (current_time > "11:35".to_time && current_time < "13:00".to_time)
      return if (current_time < "9:30".to_time || current_time > "15:05".to_time)

      duration = '1d'
      stock_lists_1 = UserStockListRel.watching_list_daily
      stock_lists_2 = UserStockListRel.watching_list_tryout
      stock_lists = stock_lists_1.union(stock_lists_2)

      # stock_lists.each do |stock_list|
      Parallel.each(stock_lists, in_processes: 4) do |stock_list|
        stock_code = stock_list.stock_code
        StockAnalyseJob.perform_now stock_code, duration
      end
    end
  end

  every(1.minute, 'stock.quotations_min', :thread => true)
  every(1.day, 'stock.quotations_daily', :at => '10:00', :thread => true)
  every(1.day, 'stock.quotations_daily', :at => '14:30', :thread => true)
  every(1.day, 'stock.list', :at => '19:00')
  # every(1.minute, 'timing', :skip_first_run => true, :thread => true)
  # every(1.hour, 'hourly.job')
end

# cd /var/www/panda_quant/current/lib/job && clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb start --log -d /Users/hielf/workspace/projects/panda_quant/lib/job
# clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb stop

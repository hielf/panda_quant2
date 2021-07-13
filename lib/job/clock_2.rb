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
    current_time = Time.zone.now
    return if (current_time.saturday? || current_time.sunday?)
    return if (current_time > "12:00".to_time && current_time < "13:00".to_time)
    return if (current_time < "9:30".to_time || current_time > "15:00".to_time)

    if job == 'minute'
      Rails.logger.warn "minute job start"
      duration = '1m'
      stock_lists = UserStockListRel.watching_list_min

      stock_lists.each do |stock_list|
        stock_code = stock_list.stock_code
        data = ApplicationController.helpers.jq_data(stock_code, duration, 10)

        if ApplicationController.helpers.csv_row_check(stock_code, duration)
          if data
            tmp_file = ApplicationController.helpers.data_to_csv(data, stock_code, duration)
            file = ApplicationController.helpers.merge_csv(stock_code, duration)
          end
        else
          if data
            file = ApplicationController.helpers.data_to_csv(data, stock_code, duration, false)
          end
        end
      end

    end

    if job == 'daily'
      Rails.logger.warn "daily job start"
      duration = '1d'
      # get data
      stock_lists = UserStockListRel.watching_list_daily

      stock_lists.each do |stock_list|
        stock_code = stock_list.stock_code
        data = ApplicationController.helpers.jq_data(stock_code, duration, 10)

        if ApplicationController.helpers.csv_row_check(stock_code, duration)
          if data
            tmp_file = ApplicationController.helpers.data_to_csv(data, stock_code, duration)
            file = ApplicationController.helpers.merge_csv(stock_code, duration)
          end
        else
          if data
            file = ApplicationController.helpers.data_to_csv(data, stock_code, duration, false)
          end
        end
      end

      # find w shape
      stock_lists.each do |stock_list|
        ApplicationController.helpers.find_w(stock_code, duration)
      end
      # push message
    end
  end

  # every(1.minute, 'recommend.quotes', :thread => false)
  every(1.minute, 'minute', :thread => true)
  every(1.day, 'daily', :at => '10:00', :thread => true)
  every(1.day, 'daily', :at => '14:30', :thread => true)
  # every(1.minute, 'timing', :skip_first_run => true, :thread => true)
  # every(1.hour, 'hourly.job')
end

# cd /var/www/panda_quant/current/lib/job && clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb start --log -d /Users/hielf/workspace/projects/panda_quant/lib/job
# clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb stop

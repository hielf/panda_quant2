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

    if job == 'tryout'
      data_1 = ApplicationController.helpers.jq_index_stocks_http("000300.XSHG")
      data_2 = ApplicationController.helpers.jq_index_stocks_http("399006.XSHE")
      lists_1 = CSV.parse(data_1)
      lists_2 = CSV.parse(data_2)
      lists = lists_1 + lists_2
      package = Package.find_by(package_type: "新手礼包")
      subscribtions = Subscribtion.tryouts.today

      subscribtions.each do |sub|
        lists.each do |l|
          stock_code = l[0][0..5]
          p stock_code
          stock_list = StockList.find_by(stock_code: stock_code)
          sub.user.tryout!(stock_list)

          stock_analyse = StockAnalyse.where(stock_code: stock_code).today.last
          if stock_analyse
            begin
              notification = sub.user.push_notifications.find_or_initialize_by(
                note_type: "推送通知",
                stock_code: stock_analyse.stock_code,
                stock_display_name: stock_analyse.stock_display_name,
                duration: stock_analyse.duration,
                begin_time: stock_analyse.begin_time,
                end_time: stock_analyse.end_time,
                stock_analyse_id: stock_analyse.id
              )
              if notification.save!
                NotificationJob.perform_later notification.id
              end
            rescue Exception => e
              Rails.logger.warn "StockAnalyseJob failed: #{e}"
            end
          end
        end
      end
    end
  end

  # every(1.minute, 'recommend.quotes', :thread => false)
  every(1.hour, 'tryout', :thread => true)
  # every(1.day, 'tryout', :at => '12:05', :thread => true)
  # every(1.day, 'tryout', :at => '15:05', :thread => true)
  # every(1.minute, 'timing', :skip_first_run => true, :thread => true)
  # every(1.hour, 'hourly.job')
end

# cd /var/www/panda_quant/current/lib/job && clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb start --log -d /Users/hielf/workspace/projects/panda_quant/lib/job
# clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb stop

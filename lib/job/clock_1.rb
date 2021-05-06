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
      p "start stock.list"
      ApplicationController.helpers.get_all_stock_list
    end
  end

  # every(1.minute, 'recommend.quotes', :thread => false)
  every(1.day, 'stock.list', :at => '19:00')
  # every(1.minute, 'timing', :skip_first_run => true, :thread => true)
  # every(1.hour, 'hourly.job')
end

# cd /var/www/panda_quant/current/lib/job && clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb start --log -d /Users/hielf/workspace/projects/panda_quant/lib/job
# clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb stop

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

    end

    if job == 'daily'
      Rails.logger.warn "daily job start"
      duration = '1d'
    
  end

  # every(1.minute, 'recommend.quotes', :thread => false)
  every(1.minute, 'minute', :thread => true)
  every(1.day, 'daily', :at => '10:05', :thread => true)
  every(1.day, 'daily', :at => '14:35', :thread => true)
  # every(1.minute, 'timing', :skip_first_run => true, :thread => true)
  # every(1.hour, 'hourly.job')
end

# cd /var/www/panda_quant/current/lib/job && clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb start --log -d /Users/hielf/workspace/projects/panda_quant/lib/job
# clockworkd -c clock_1.rb start --log -d /var/www/panda_quant/current/lib/job
# clockworkd -c clock_1.rb stop

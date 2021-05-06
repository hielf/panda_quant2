# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# every :reboot do
#   command "service ssh start"
#   command "service nginx start"
#   command "cd /var/www/panda_quant2/current && /usr/local/rvm/bin/rvm 2.4.0@panda_quant2 do bundle exec puma -C /var/www/panda_quant2/shared/puma.rb --daemon"
#   command "cd /var/www/panda_quant2/current && /usr/local/rvm/bin/rvm 2.4.0@panda_quant2 do bundle exec pumactl -S /var/www/panda_quant2/shared/tmp/pids/puma.state -F /var/www/panda_quant2/shared/puma.rb restart"
#   command "cd /var/www/panda_quant2-frontend/ && pm2 start server/app.js"
# end


# every 1.minutes do
#   rake "recommend:quotes"
# end
#
# every 1.day, at: ['7:00 pm'] do
#   rake "stock:list"
# end
#
# every 1.day, at: ['9:00 pm'] do
#   rake "stock:reports"
# end
#
# every 1.day, at: ['1:30 am'] do
#   rake "stock:generate"
# end
# every 1.day, at: '6:00' do
#   command "cat /dev/null > /var/www/panda_ib/current/log/puma.access.log"
#   command "cat /dev/null > /var/www/panda_ib/current/log/puma.error.log"
# end

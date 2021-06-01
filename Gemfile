# source 'https://rubygems.org'
# source 'https://ruby.taobao.org'
source 'https://gems.ruby-china.com'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.3'
gem 'mysql2'
# gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
# gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# gem "therubyracer"
gem 'figaro'
# gem 'execjs'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# group :production do
#   gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# end

gem 'rack-cors', :require => 'rack/cors'
gem 'prime'
gem 'kaminari'
gem 'ransack'
gem 'whenever', :require => false
gem 'timeout-extensions'
gem 'parallel'
gem 'wechat'
gem 'wx_pay'
gem 'httparty'
gem 'state_machines-activerecord'
gem 'validates_lengths_from_database'
gem 'pycall'
gem 'rb-readline'
gem 'ruby-pinyin'
gem 'qiniu', '>= 6.9.0'
gem 'tzinfo-data'
# gem 'postgres-copy'
# gem 'dbf'
gem 'clockwork'
gem 'daemons'
gem "webpacker", "~> 5.3"
gem "react_on_rails", "= 12.2.0"
gem 'mini_racer', platforms: :ruby

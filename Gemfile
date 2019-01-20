source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# use fot autherization (latest)
gem 'cancan', '1.6.10'
# use for pagination (latest)
gem 'will_paginate', '3.1.6'
# use for user management (authentication) (latest)
gem 'devise', '4.5.0'
# Use mysql as the database for Active Record (compatible)
gem 'mysql2', '0.3.21'
# add bootstrap to rails application
gem 'bootstrap-sass', '3.3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.7'
# Use Uglifier as compressor for JavaScript assets (latest)
gem 'uglifier', '4.1.20'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library (latest)
gem 'jquery-rails', '4.3.3'
# Turbolinks makes following links in your web application faster.
gem 'turbolinks', '5.2.0' # (latest)
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.8.0' # latest
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop
  # execution and get a debugger console
  gem 'byebug'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development do
  gem 'brakeman', require: false
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'rails_best_practices', require: false
  gem 'rubocop', '~> 0.62.0', require: false
end

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'

# Gemfile

# Update the Rails version
gem 'rails', '~> 7.1.2'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 6.4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# API calls
gem 'rest-client'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.17.1', require: false

# Devise app for user sign in
gem 'devise'

#  oauth gem for github
gem 'omniauth-github', '~> 2.0.1'

# omniauth for login with authentication
gem 'omniauth'
gem 'omniauth-oauth2-generic'

gem 'omniauth-rails_csrf_protection'

# replacing webpacker with importmap-rails
gem 'importmap-rails'

#  GitHub API client
gem 'octokit', '~> 5.0'

group :development, :test do
  # Call 'byebug' or 'binding.pry' anywhere in the code to stop execution and get a debugger console
  # gem "pry-byebug" #does not play well with 'pry-remote'
  gem 'pry-remote'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.2.1'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.8.0'
  gem 'rack-mini-profiler', '~> 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.39.2'
  gem 'selenium-webdriver', '>= 4.17.0.rc1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'tailwindcss-rails', '~> 2.3.0'

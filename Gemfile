source "https://rubygems.org"
ruby   "2.2.2"

# Rails
gem "rails", "~> 4.2.1"

# Database
gem "pg", "~> 0.18.2"

# SCSS for stylesheets, using the bootstrap framework
gem "sass-rails", "~> 5.0"
gem "bootstrap-sass", "~> 3.3.4"

# Uglifier to compress JavaScript
gem "uglifier", "~> 2.7.1"

# jQuery
gem "jquery-rails", "~> 4.0.3"

# Underscore
gem "underscore-rails", "~> 1.8.2"

# Manage JS modules with Browserify
gem "browserify-rails", "~> 0.9.1"

# React
# Server-side rendering
gem "therubyracer", "~> 0.12.2", platforms: :ruby
gem "react-rails", "~> 1.0.0"

# JSON templating
gem "jbuilder", "~> 2.0"

# Exception tracking
gem "sentry-raven", "~> 0.13.3"

# Authentication
gem 'bcrypt', '~> 3.1.0'

group :development, :test do
  # Call "byebug" anywhere to stop execution and get a debugger console
  gem "byebug"

  # IRB console on exception pages
  gem "web-console"

  # Keep application running in the background
  gem "spring"
  gem "spring-commands-rspec"

  # Rspec for testing
  gem "rspec-rails", "~> 3.0"
  gem "shoulda-matchers", require: false
  gem "database_cleaner"

  # Test formating and print instant-fail
  gem "fuubar"

  # Factories
  gem "factory_girl_rails"
  gem "faker"

  # Capybara for acceptance testing
  gem "capybara"
  gem "poltergeist"

  # Pry for debugging
  gem "pry"
end

group :production do
  # App server
  gem "puma", "~> 2.11.3"

  # Heroku logging and assets
  gem "rails_12factor", "~> 0.0.3"
end

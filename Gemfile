source 'http://rubygems.org'

gem 'capistrano'
gem 'devise'
gem 'eco'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mongoid'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'rails', '3.2.12'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass-rails'
end

group :development, :qa, :staging do
  gem 'debugger'
  gem 'sextant'
  gem 'thin'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem 'launchy'
  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'mongoid-rspec'
  gem 'simplecov', require: false
end


ruby '2.2.1'
source 'https://rubygems.org'

gem 'sinatra-activerecord'
gem 'sinatra'
gem 'json'
gem 'oauth'

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'cucumber'
  gem 'rspec'
  gem 'rack-test'
  gem 'pry'
  gem 'coveralls'
end

group :production do
  gem 'pg'
  gem 'redis'
end

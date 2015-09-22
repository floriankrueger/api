
require 'bundler'
Bundler.require

unless ENV['RACK_ENV'] == 'test'
  set :database_file, "./config/database.yml"
end

require 'cocoa_conferences'

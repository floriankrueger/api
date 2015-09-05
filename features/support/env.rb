
require 'bundler'
Bundler.require

require 'rspec/expectations'

set :database_file, "../../config/database.yml"

require './lib/cocoa_conferences'

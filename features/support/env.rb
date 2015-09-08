
require 'bundler'
Bundler.require

require './lib/cocoa_conferences'

# fakes
require './lib/fakes/fake_oauth'
require './lib/fakes/fake_redis'

ENV['RACK_ENV'] = 'test'

app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
Sinatra::Application.app_file = app_file

require 'rspec/expectations'
require 'rack/test'

set :database_file, "config/database.yml"

class CocoaConferencesTests
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

World{CocoaConferencesTests.new}

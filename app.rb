#
# cocoaconferences.org
#
# Learn more about your favourite conferences for Cocoa developers, discover new conferences and
# interact with organisers and attendees.
#

require 'bundler'
Bundler.require

require 'sinatra'
require 'json'

unless ENV['RACK_ENV'] == 'test'
  set :database_file, "./config/database.yml"
end

get "/?" do
  content_type "application/hal+json"
  { :_links => {
    :events =>      { :href => "/events" },
    :conferences => { :href => "/conferences" },
    :cities =>      { :href => "/cities" },
    :countries =>   { :href => "/countries" },
    :continents =>  { :href => "/continents" }
    }
  }.to_json
end

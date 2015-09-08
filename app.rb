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

post "/users/?" do
  case params[:method]
  when 'pin'
    status 501
  else
    error = Error.new(message: "Please supply a valid authentication method.", info: { :supported_methods => ['pin'] })
    status 400
    error.to_json
  end
end

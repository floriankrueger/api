require 'bundler'
Bundler.require

require 'sinatra'
require 'json'

set :database_file, "./config/database.yml"

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

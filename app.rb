require 'sinatra'
require 'json'

require './config/environments'

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

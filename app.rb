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

set :show_exceptions, :after_handler

before do
  if env['HTTP_AUTHENTICATION']
    auth = AuthHeader.new(header_string: env['HTTP_AUTHENTICATION'])
    client = TwitterClient.instance
    @session = client.get_session(session_token: auth.token, session_secret: auth.secret)
  end
end

get "/?" do
  content_type "application/hal+json"
  { :_links => {
    :events =>          { :href => "/events" },
    :conferences =>     { :href => "/conferences" },
    :cities =>          { :href => "/cities" },
    :countries =>       { :href => "/countries" },
    :continents =>      { :href => "/continents" },
    :authentication =>  { :href => "/auth" }
    }
  }.to_json
end

require './app/auth'
require './app/events'

# Errors

def error_from_sinatra_error
  { :error => { :message => env['sinatra.error'].message } }.to_json
end

error ActiveRecord::RecordNotFound do
  halt 404
end

error ArgumentError do
  halt 400, { "Content-Type" => "application/json" }, error_from_sinatra_error
end

error NotFoundError do
  halt 404, { "Content-Type" => "application/json" }, error_from_sinatra_error
end

error AuthenticationFailed do
  halt 401, { "Content-Type" => "application/json" }, error_from_sinatra_error
end

error LocationValidationError do
  halt 400, { "Content-Type" => "application/json" }, error_from_sinatra_error
end

error ConferenceValidationError do
  halt 400, { "Content-Type" => "application/json" }, error_from_sinatra_error
end

error EventValidationError do
  halt 400, { "Content-Type" => "application/json" }, error_from_sinatra_error
end

error InternalServerError do
  halt 500, { 'Content-Type' => 'application/json' }, error_from_sinatra_error
end

error do
  halt 500, { 'Content-Type' => 'application/json' }, error_from_sinatra_error
end

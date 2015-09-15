$:.unshift File.expand_path("./../lib", __FILE__)

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require "cocoa_conferences"
    require "./app"
  end
end

$:.unshift File.expand_path("./../lib", __FILE__

require 'cocoa_conferences'
require './app'
run Sinatra::Application

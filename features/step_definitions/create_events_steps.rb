
require 'bundler'
Bundler.require

require 'minitest/autorun'

set :database_file, "../../config/database.yml"

class Event < ActiveRecord::Base
end

Given(/^There are no events in the database$/) do
  assert_equal 0, Event.count
end

Given(/^A new event is created$/) do
  Event.create()
end

Then(/^There should be one event in the database$/) do
  assert_equal 1, Event.count
end


require 'bundler'
Bundler.require

require 'rspec/expectations'

set :database_file, "../../config/database.yml"

class Event < ActiveRecord::Base
end

Given(/^There are no events in the database$/) do
  expect(Event.count).to eq(0)
end

Given(/^A new event is created$/) do
  Event.create()
end

Then(/^There should be one event in the database$/) do
  expect(Event.count).to eq(1)
end

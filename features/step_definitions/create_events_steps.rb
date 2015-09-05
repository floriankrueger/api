
Given(/^There are no events in the database$/) do
  expect(Event.count).to eq(0)
end

When(/^A new event is created$/) do
  Event.create()
end

Then(/^There should be one event in the database$/) do
  expect(Event.count).to eq(1)
end

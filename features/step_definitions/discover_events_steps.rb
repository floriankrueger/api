
Given(/^The user isn't authenticated$/) do
header "Authentication", nil
end

When(/^He fetches the root via GET$/) do
  get "/"
end

Then(/^There is a _links Hash with (\d+) elements$/) do |arg1|
  @data = JSON.parse(last_response.body)
  expect(@data['_links']).not_to be_nil
  expect(@data['_links']).not_to be_empty
  expect(@data['_links'].keys.length).to eq(arg1.to_i)
end

Then (/^There is a link to the ([a-z]+) with an href of ([a-z\/]+)$/) do |arg1,arg2|
  expect(@data['_links'][arg1]).not_to be_nil
  expect(@data['_links'][arg1]['href']).to eq(arg2)
end

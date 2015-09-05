
Given(/^The user isn't authenticated$/) do
header "Authentication", nil
end

When(/^He fetches the root via GET$/) do
  get "/"
end

Then(/^The HTTP Status Code should be 200$/) do
  expect(last_response.status).to eq(200)
end

Then(/^There is a _links Hash with 5 elements$/) do
  @data = JSON.parse(last_response.body)
  expect(@data['_links']).not_to be_nil
  expect(@data['_links']).not_to be_empty
  expect(@data['_links'].keys.length).to eq(5)
end

Then(/^There is a link to the events$/) do
  expect(@data['_links']['events']).not_to be_nil
  expect(@data['_links']['events']['href']).to eq('/events')
end

Then(/^There is a link to the conferences$/) do
  expect(@data['_links']['conferences']).not_to be_nil
  expect(@data['_links']['conferences']['href']).to eq('/conferences')
end

Then(/^There is a link to the cities$/) do
  expect(@data['_links']['cities']).not_to be_nil
  expect(@data['_links']['cities']['href']).to eq('/cities')
end

Then(/^There is a link to the countries$/) do
  expect(@data['_links']['countries']).not_to be_nil
  expect(@data['_links']['countries']['href']).to eq('/countries')
end

Then(/^There is a link to the continents$/) do
  expect(@data['_links']['continents']).not_to be_nil
  expect(@data['_links']['continents']['href']).to eq('/continents')
end

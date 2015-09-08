
When(/^The user sends a post to \/users with an unsupported method$/) do
  post "/users?method=something_unsupported"
end

Then(/^The HTTP Status Code should be (\d+)$/) do |arg1|
  expect(last_response.status).to eq(arg1.to_i)
end

Then(/^There should be an Error$/) do
  data = JSON.parse(last_response.body)
  expect(data['error']).not_to be_nil
end

Then(/^The Error message should say that a valid authentication method is needed$/) do
  data = JSON.parse(last_response.body)
  expect(data['error']['message']).to eq("Please supply a valid authentication method.")
end

Then(/^The Info object should contain a list of supported methods$/) do
  data = JSON.parse(last_response.body)
  expect(data['error']['info']['supported_methods']).to be_an(Array)
  expect(data['error']['info']['supported_methods']).to eq(['pin'])
end

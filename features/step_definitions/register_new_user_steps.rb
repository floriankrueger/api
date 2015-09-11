
Given(/^The OAuth Client is fake$/) do
  @fake_oauth_client = FakeOAuth.new()
  TwitterClient.instance.consumer = @fake_oauth_client
end

Given(/^The Redis Store is fake$/) do
  @fake_redis_store = FakeRedis.new()
  TwitterClient.instance.store = @fake_redis_store
end

When(/^The user sends a post to \/auth\/challenges without a method$/) do
  post "/auth/challenges"
end

When(/^The user sends a post to \/auth\/challenges with an unsupported method$/) do
  post "/auth/challenges?method=something_unsupported"
end

When(/^The user sends a post to \/auth\/challenges using the method pin$/) do
  post "/auth/challenges?method=pin"
end

Then(/^The HTTP Status Code should be (\d+)$/) do |arg1|
  expect(last_response.status).to eq(arg1.to_i)
end

Then(/^There should be an Error$/) do
  data = JSON.parse(last_response.body)
  expect(data['error']).not_to be_nil
end

Then(/^The Error message should say "([^"]*)"$/) do |arg1|
data = JSON.parse(last_response.body)
expect(data['error']['message']).to eq(arg1)
end

Then(/^The Fake OAuth Client should have been called with the PIN method$/) do
  expect(@fake_oauth_client.last_params).to_not be_nil
  expect(@fake_oauth_client.last_params[:oauth_callback]).to eq('oob')
end

Then(/^There is a link to the twitter authentication page$/) do
  data = JSON.parse(last_response.body)
  expect(data['external_auth_url']).to_not be_nil
end

Then(/^There is a self link to the challenge$/) do
  data = JSON.parse(last_response.body)
  expect(data['_links']['self']).to_not be_nil
  expect(data['_links']['self']['href']).to_not be_nil
end

Then(/^The Location Header should point to the Challenge$/) do
  data = JSON.parse(last_response.body)
  challenge_url = data['_links']['self']['href']
  expect(last_response.headers['Location']).to eq(challenge_url)
end

Then(/^A fake PIN Challenge should have been created$/) do
  data = JSON.parse(last_response.body)
  token = data['_links']['self']['href'].split('/').last
  challenge = JSON.parse(@fake_redis_store.get(token))
  expect(challenge).to_not be_nil
  expect(challenge['token']).to eq(@fake_oauth_client.request_token.token)
  expect(challenge['secret']).to eq(@fake_oauth_client.request_token.secret)
  expect(challenge['method']).to eq('pin')
end

Given(/^The user has never logged in before$/) do
  expect(User.count).to eq(0)
end

Given(/^There is a pending Twitter PIN Challenge$/) do
  post "/auth/challenges?method=pin"
  expect(last_response.headers['Location']).to_not be_nil
end

Given(/^The Session Master Key is "([^"]*)"$/) do |arg1|
  ENV['SESSION_MASTER_KEY'] = arg1
end

Given(/^There is no pending Twitter PIN Challenge for the key ([a-zA-Z0-9]+)$/) do |arg1|
  expect(@fake_redis_store.get(arg1)).to be_nil
end

When(/^The user sends a POST to the challenge ([a-zA-Z0-9]+) with some auth data$/) do |arg1|
  post "/auth/challenges/#{arg1}", { "pin" => "123456" }.to_json, { "Content-Type" => "application/json" }
end

When(/^The user sends a POST to the given challenge url with no auth data$/) do
  post last_response.headers['Location'], {}.to_json, { "Content-Type" => "application/json" }
end

When(/^The user sends a POST to the given challenge url with a PIN of ([a-zA-Z0-9]+)$/) do |arg1|
  post last_response.headers['Location'], { "pin" => arg1 }.to_json, { "Content-Type" => "application/json" }
end

Then(/^The Fake OAuth Client should have been called with the a PIN of ([a-zA-Z0-9]+)$/) do |arg1|
  expect(@fake_oauth_client.last_params).to_not be_nil
  expect(@fake_oauth_client.last_params[:oauth_verifier]).to eq(arg1)
end

Then(/^A user account should have been created$/) do
  expect(User.count).to eq(1)
end

Then(/^There is a link to the user$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^There is an session_token$/) do
  data = JSON.parse(last_response.body)
  expect(data['session_token']).to_not be_nil
end

Then(/^There is an session_secret$/) do
  data = JSON.parse(last_response.body)
  expect(data['session_secret']).to_not be_nil
end

Then(/^The access_token has been stored$/) do
  data = JSON.parse(last_response.body)
  session_token = data['session_token']
  expect(@fake_redis_store.get(session_token)).to_not be_nil
end

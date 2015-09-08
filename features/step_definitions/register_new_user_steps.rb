
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

Then(/^The Error message should say that a valid authentication method is needed$/) do
  data = JSON.parse(last_response.body)
  expect(data['error']['message']).to eq("Please supply a valid authentication method. Supported methods are: pin")
end

Then(/^The Fake OAuth Client should have been called with the PIN method$/) do
  expect(@fake_oauth_client.last_params).to_not be_nil
  expect(@fake_oauth_client.last_params[:oauth_callback]).to eq('oob')
end

Then(/^A fake Challenge should have been created$/) do
  data = JSON.parse(last_response.body)
  token = data['_links']['challenge']['href'].split('/').last
  challenge = JSON.parse(@fake_redis_store.get(token))
  expect(challenge).to_not be_nil
  expect(challenge['token']).to eq(@fake_oauth_client.request_token.token)
  expect(challenge['secret']).to eq(@fake_oauth_client.request_token.secret)
end

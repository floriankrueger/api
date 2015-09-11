
Given(/^The OAuth Client is fake$/) do
  @fake_oauth_client = FakeOAuth.new()
  TwitterClient.instance.consumer = @fake_oauth_client
end

Given(/^The OAuth Client will return a valid User Response$/) do
  @fake_oauth_client.response = FakeResponse.new(body: '{"id":16497772,"id_str":"16497772","name":"floriankrueger","screen_name":"xcuze","location":"Munich, Germany","description":"Software Developer & Enthusiast","url":"http:\/\/t.co\/cLR2xAhpp3","entities":{"url":{"urls":[{"url":"http:\/\/t.co\/cLR2xAhpp3","expanded_url":"http:\/\/about.me\/floriankrueger","display_url":"about.me\/floriankrueger","indices":[0,22]}]},"description":{"urls":[]}},"protected":false,"followers_count":99,"friends_count":139,"listed_count":8,"created_at":"Sun Sep 28 12:49:36 +0000 2008","favourites_count":116,"utc_offset":7200,"time_zone":"Berlin","geo_enabled":true,"verified":false,"statuses_count":955,"lang":"en","status":{"created_at":"Thu Sep 10 14:11:05 +0000 2015","id":641977194793828352,"id_str":"641977194793828352","text":"RT @MicroSFF: \"Okay Google,\" Cortana said, \"who was the antagonist of \'I am weasel\'?\"\n\"I are baboon.\" Google paused. \"Real mature, guys.\"\nS\u2026","source":"\u003ca href=\"http:\/\/twitter.com\" rel=\"nofollow\"\u003eTwitter Web Client\u003c\/a\u003e","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"geo":null,"coordinates":null,"place":null,"contributors":null,"retweeted_status":{"created_at":"Thu Sep 10 13:28:04 +0000 2015","id":641966370461233152,"id_str":"641966370461233152","text":"\"Okay Google,\" Cortana said, \"who was the antagonist of \'I am weasel\'?\"\n\"I are baboon.\" Google paused. \"Real mature, guys.\"\nSiri giggled.","source":"\u003ca href=\"http:\/\/www.hootsuite.com\" rel=\"nofollow\"\u003eHootsuite\u003c\/a\u003e","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"geo":null,"coordinates":null,"place":null,"contributors":null,"retweet_count":78,"favorite_count":94,"entities":{"hashtags":[],"symbols":[],"user_mentions":[],"urls":[]},"favorited":false,"retweeted":true,"lang":"en"},"retweet_count":78,"favorite_count":0,"entities":{"hashtags":[],"symbols":[],"user_mentions":[{"screen_name":"MicroSFF","name":"Micro SF\/F Fiction","id":1376608884,"id_str":"1376608884","indices":[3,12]}],"urls":[]},"favorited":false,"retweeted":true,"lang":"en"},"contributors_enabled":false,"is_translator":false,"is_translation_enabled":false,"profile_background_color":"131516","profile_background_image_url":"http:\/\/pbs.twimg.com\/profile_background_images\/378800000085326876\/a0f77b0807499a41bdfbe71032912af8.jpeg","profile_background_image_url_https":"https:\/\/pbs.twimg.com\/profile_background_images\/378800000085326876\/a0f77b0807499a41bdfbe71032912af8.jpeg","profile_background_tile":false,"profile_image_url":"http:\/\/pbs.twimg.com\/profile_images\/637326380418629632\/kQCnyVXR_normal.jpg","profile_image_url_https":"https:\/\/pbs.twimg.com\/profile_images\/637326380418629632\/kQCnyVXR_normal.jpg","profile_banner_url":"https:\/\/pbs.twimg.com\/profile_banners\/16497772\/1440785685","profile_link_color":"006699","profile_sidebar_border_color":"FFFFFF","profile_sidebar_fill_color":"EFEFEF","profile_text_color":"333333","profile_use_background_image":true,"has_extended_profile":false,"default_profile":false,"default_profile_image":false,"following":false,"follow_request_sent":false,"notifications":false}')
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

Then(/^The Location Header should point to the User$/) do
  screen_name = JSON.parse(@fake_oauth_client.response.body)['screen_name']
  expect(last_response.headers['Location']).to eq("/users/#{screen_name}")
end

Then(/^A user account should have been created$/) do
  expect(User.count).to eq(1)
end

Then(/^The user account should contain all information from the response$/) do
  response = JSON.parse(@fake_oauth_client.response.body)
  screen_name = response['screen_name']
  user = User.where(:screen_name => screen_name).first

  expect(user).to_not be_nil
  expect(user.name).to eq(response['name'])
  expect(user.screen_name).to eq(response['screen_name'])
  expect(user.location).to eq(response['location'])
  expect(user.description).to eq(response['description'])
  expect(user.profile_image_url).to eq(response['profile_image_url'])
  expect(user.expanded_url).to eq(response['expanded_url'])
  expect(user.domain).to eq('twitter')
end

Then(/^There is a link to the user$/) do
  screen_name = JSON.parse(@fake_oauth_client.response.body)['screen_name']
  data = JSON.parse(last_response.body)
  expect(data['_links']['user']['href']).to eq("/users/#{screen_name}")
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


Given(/^The user is authenticated with invalid token and secret$/) do
  header "Authentication", "CC-AUTH token=\"not_a_token\", secret=\"not_a_secret\""
end

Given(/^The user is authenticated with invalid authentication header scheme$/) do
  header "Authentication", "WHATEVER foo=\"bar\""
end

Given(/^The user is authenticated with missing token$/) do
  header "Authentication", "CC-AUTH foo=\"not_a_token\", secret=\"not_a_secret\""
end

Given(/^The user is authenticated with missing secret$/) do
  header "Authentication", "CC-AUTH token=\"not_a_token\", bar=\"not_a_secret\""
end

Given(/^The user is authenticated with invalid secret$/) do
  token = @current_session_info[:session_token]
  header "Authentication", "CC-AUTH token=\"#{token}\", secret=\"not_a_secret\""
end

Given(/^The user is authenticated$/) do
  token = @current_session_info[:session_token]
  secret = @current_session_info[:session_secret]
  header "Authentication", "CC-AUTH token=\"#{token}\", secret=\"#{secret}\""
end

Given(/^The user has already logged in before$/) do
  User.create(
    :name => "floriankrueger",
    :screen_name => "xcuze",
    :location => "somewhere over the rainbow",
    :description => "this is a work in progress",
    :profile_image_url => "http://example.org",
    :expanded_url => "http://geocities.com/xcuze",
    :external_id => "16497772",
    :domain => 'twitter'
  )
  expect(User.count).to eq(1)
end

Given(/^The user is logged in$/) do
  client = TwitterClient.instance
  @current_session_info = client.create_session(token: "oauth_token", secret: "oauth_secret")
end

Then(/^No new user account should have been created$/) do
  expect(User.count).to eq(1)
end

Then(/^The Location Header should be empty$/) do
  expect(last_response.headers['Location']).to be_nil
end

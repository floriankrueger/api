
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

Then(/^No new user account should have been created$/) do
  expect(User.count).to eq(1)
end

Then(/^The Location Header should be empty$/) do
  expect(last_response.headers['Location']).to be_nil
end


When(/^The user sends a GET to \/continents$/) do
  get "/continents"
end

When(/^The user sends a GET to \/continents\/([a-z]+)$/) do |arg1|
  get "/continents/#{arg1}"
end

When(/^The user sends a GET to \/continents\/([a-z]+)\/([a-z]+)$/) do |arg1, arg2|
  get "/continents/#{arg1}/#{arg2}"
end

Then(/^There is a field "([^"]*)" with a value of "([^"]*)"$/) do |arg1, arg2|
  data = JSON.parse(last_response.body)
  expect(data[arg1]).to eq(arg2)
end

Then(/^Every item in the list is a valid continent$/) do
  data = JSON.parse(last_response.body)
  continents = data['_embedded']['cc:continent']

  continents.each do |continent|
    code = continent["code"]

    expect(code).not_to be_nil
    expect(continent["name"]).not_to be_nil

    expect(continent["_links"]).not_to be_nil
    expect(continent["_links"].keys.length).to eq(3)
    expect(continent["_links"]["self"]["href"]).to eq("/continents/#{code}")
    expect(continent["_links"]["cc:country"]["href"]).to eq("/continents/#{code}/countries")
    expect(continent["_links"]["cc:event"]["href"]).to eq("/continents/#{code}/events")
  end
end

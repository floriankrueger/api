
When(/^The user sends a GET to \/cities$/) do
  get "/cities"
end

When(/^The user sends a GET to \/cities\/([a-z]+)$/) do |arg1|
  get "/cities/#{arg1}"
end

When(/^The user sends a GET to \/cities\/([a-z]+)\/([a-z]+)$/) do |arg1,arg2|
  get "/cities/#{arg1}/#{arg2}"
end

Then(/^Every item in the list is a valid city$/) do
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']

  cities.each do |city|
    code = city["code"]

    expected_city = City.where(:code => code).first

    expect(code).not_to be_nil
    expect(city["name"]).not_to be_nil

    expect(city["_links"]).not_to be_nil
    expect(city["_links"].keys.length).to eq(4)
    expect(city["_links"]["self"]["href"]).to eq("/cities/#{code}")
    expect(city["_links"]["cc:country"]["href"]).to eq("/countries/#{expected_city.country.code}")
    expect(city["_links"]["cc:continent"]["href"]).to eq("/continents/#{expected_city.country.continent.code}")
    expect(city["_links"]["cc:event"]["href"]).to eq("/cities/#{code}/events")
  end
end

Then(/^The first city should be Aberystwyth$/) do
  # fetch the expected data from database
  aberystwyth = City.where(:code => "gbayw").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']
  city = cities[0]

  # make sure the data is correct
  check_city(city, aberystwyth)
end

Then(/^The second city should be Edinburgh$/) do
  # fetch the expected data from database
  edinburgh = City.where(:code => "gbedi").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']
  city = cities[1]

  # make sure the data is correct
  check_city(city, edinburgh)
end

Then(/^The third city should be Logroño$/) do
  # fetch the expected data from database
  logrono = City.where(:code => "eslgr").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']
  city = cities[2]

  # make sure the data is correct
  check_city(city, logrono)
end

Then(/^The fourth city should be London$/) do
  # fetch the expected data from database
  london = City.where(:code => "gblon").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']
  city = cities[3]

  # make sure the data is correct
  check_city(city, london)
end

Then(/^The fifth city should be San Fransisco$/) do
  # fetch the expected data from database
  san_francisco = City.where(:code => "ussfo").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']
  city = cities[4]

  # make sure the data is correct
  check_city(city, san_francisco)
end

Then(/^The third city should be London$/) do
  # fetch the expected data from database
  london = City.where(:code => "gblon").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  cities = data['_embedded']['cc:city']
  city = cities[2]

  # make sure the data is correct
  check_city(city, london)
end

def check_city(actual_city, expected_city)
  expect(actual_city["_links"]["self"]["href"]).to eq(expected_city.href)
  expect(actual_city["_links"]["cc:continent"]["href"]).to eq(expected_city.country.continent.href)
  expect(actual_city["_links"]["cc:country"]["href"]).to eq(expected_city.country.href)
  expect(actual_city["_links"]["cc:event"]["href"]).to eq(expected_city.events_href)

  expect(actual_city["code"]).to eq(expected_city.code)
  expect(actual_city["name"]).to eq(expected_city.name)
end

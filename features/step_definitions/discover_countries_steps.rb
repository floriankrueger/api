
When(/^The user sends a GET to \/countries$/) do
  get "/countries"
end

When(/^The user sends a GET to \/countries\/([a-z]+)$/) do |arg1|
  get "/countries/#{arg1}"
end

When(/^The user sends a GET to \/countries\/([a-z]+)\/([a-z]+)$/) do |arg1,arg2|
  get "/countries/#{arg1}/#{arg2}"
end

Then(/^The first country should be Spain$/) do
  # fetch the expected data from database
  spain = Country.where(:code => "es").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  countries = data['_embedded']['cc:country']
  country = countries[0]

  # make sure the data is correct
  check_country(country, spain)
end

Then(/^The second country should be the United Kingdom$/) do
  # fetch the expected data from database
  united_kingdom = Country.where(:code => "gb").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  countries = data['_embedded']['cc:country']
  country = countries[1]

  # make sure the data is correct
  check_country(country, united_kingdom)
end

Then(/^The third country should be the United States$/) do
  # fetch the expected data from database
  united_states = Country.where(:code => "us").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  countries = data['_embedded']['cc:country']
  country = countries[2]

  # make sure the data is correct
  check_country(country, united_states)
end

def check_country(actual_country, expected_country)
  expect(actual_country["_links"]["self"]["href"]).to eq(expected_country.href)
  expect(actual_country["_links"]["cc:continent"]["href"]).to eq(expected_country.continent.href)
  expect(actual_country["_links"]["cc:city"]["href"]).to eq(expected_country.cities_href)
  expect(actual_country["_links"]["cc:event"]["href"]).to eq(expected_country.events_href)

  expect(actual_country["code"]).to eq(expected_country.code)
  expect(actual_country["name"]).to eq(expected_country.name)
end

Then(/^Every item in the list is a valid country$/) do
  data = JSON.parse(last_response.body)
  countries = data['_embedded']['cc:country']

  countries.each do |country|
    code = country["code"]

    expected_country = Country.where(:code => code).first

    expect(code).not_to be_nil
    expect(country["name"]).not_to be_nil

    expect(country["_links"]).not_to be_nil
    expect(country["_links"].keys.length).to eq(4)
    expect(country["_links"]["self"]["href"]).to eq("/countries/#{code}")
    expect(country["_links"]["cc:continent"]["href"]).to eq(expected_country.continent.href)
    expect(country["_links"]["cc:city"]["href"]).to eq("/countries/#{code}/cities")
    expect(country["_links"]["cc:event"]["href"]).to eq("/countries/#{code}/events")
  end
end

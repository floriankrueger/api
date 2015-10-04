
Then(/^The first country should be Spain$/) do
  # fetch the expected data from database
  spain = Country.where(:name => "Spain").first

  # extract the actual country
  data = JSON.parse(last_response.body)
  countries = data['_embedded']['cc:country']
  country = countries[0]

  # make sure the data is correct
  check_country(country, spain)
end

def check_country(actual_country, expected_country)
  expect(actual_country["_links"]["self"]["href"]).to eq(expected_country.href)
  expect(actual_country["_links"]["cc:continent"]["href"]).to eq(expected_country.continent.href)
  expect(actual_country["_links"]["cc:city"]["href"]).to eq(expected_country.cities_href)
  expect(actual_country["_links"]["cc:event"]["href"]).to eq(expected_country.events_href)

  expect(actual_country["code"]).to eq(expected_country.code)
  expect(actual_country["name"]).to eq(expected_country.name)
end

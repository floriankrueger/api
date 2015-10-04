
Then(/^The Error message should begin with "([^"]*)"$/) do |arg1|
  data = JSON.parse(last_response.body)
  expect(data['error']['message'].include? arg1).to be_truthy
end

Given(/^There are no events in the database$/) do
  expect(Event.count).to eq(0)
end

Given(/^There are no countries in the database$/) do
  expect(Country.count).to eq(0)
end

Given(/^There are no cities in the database$/) do
  expect(City.count).to eq(0)
end

Given(/^There are no conferences in the database$/) do
  expect(Conference.count).to eq(0)
end

When(/^The user sends a POST to the events collection without continent information$/) do
  post '/events', {}.to_json, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection with an invalid continent code "([a-zA-Z][a-zA-Z]+)"$/) do |arg1|
  body = {
      "cc:continent" => {
          "code" => arg1
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection without country information$/) do
  body = {
      "cc:continent" => {
          "code" => "oc"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection with a new country without a name$/) do
  body = {
      "cc:country" => {
          "code" => "gb"
      },
      "cc:continent" => {
          "code" => "oc"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection without city information$/) do
  body = {
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection with a new city without a name$/) do
  body = {
      "cc:city" => {
          "code" => "gblon"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection without conference information$/) do
  body = {
      "cc:city" => {
          "code" => "gblon",
          "name" => "London"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection with a new conference without a name$/) do
  body = {
      "cc:conference" => {},
      "cc:city" => {
          "code" => "gblon",
          "name" => "London"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection without a start date$/) do
  body = {
      "end" => "2015-06-17T23:59:59.999Z",
      "web" => "https://skillsmatter.com/conferences/6687-ioscon-2015-the-conference-for-ios-and-swift-developers",
      "cc:conference" => {
          "name" => "iOSCon"
      },
      "cc:city" => {
          "code" => "gblon",
          "name" => "London"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection without an end date$/) do
  body = {
      "start" => "2015-06-15T00:00:00.000Z",
      "web" => "https://skillsmatter.com/conferences/6687-ioscon-2015-the-conference-for-ios-and-swift-developers",
      "cc:conference" => {
          "name" => "iOSCon"
      },
      "cc:city" => {
          "code" => "gblon",
          "name" => "London"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

When(/^The user sends a POST to the events collection without website information$/) do
  body = {
      "start" => "2015-06-15T00:00:00.000Z",
      "end" => "2015-06-17T23:59:59.999Z",
      "cc:conference" => {
          "name" => "iOSCon"
      },
      "cc:city" => {
          "code" => "gblon",
          "name" => "London"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

Then(/^There should be (\d+) event(s)? in the database$/) do |arg1,arg2|
  expect(Event.count).to eq(arg1.to_i)
end

Then(/^There should be (\d+) countr(y|ies) in the database$/) do |arg1,arg2|
  expect(Country.count).to eq(arg1.to_i)
end

Then(/^There should be (\d+) cit(y|ies) in the database$/) do |arg1,arg2|
  expect(City.count).to eq(arg1.to_i)
end

Then(/^There should be (\d+) conference(s)? in the database$/) do |arg1,arg2|
  expect(Conference.count).to eq(arg1.to_i)
end


Given(/^The continents are setup$/) do
  Continent.where(:code => "af").first_or_create!(:name => "Africa")
  Continent.where(:code => "an").first_or_create!(:name => "Antarctica")
  Continent.where(:code => "as").first_or_create!(:name => "Asia")
  Continent.where(:code => "eu").first_or_create!(:name => "Europe")
  Continent.where(:code => "na").first_or_create!(:name => "North America")
  Continent.where(:code => "oc").first_or_create!(:name => "Oceania")
  Continent.where(:code => "sa").first_or_create!(:name => "South America")
end

When(/^The user sends a POST to the events collection with a valid body$/) do
  body = {
      "start" => "2015-06-15T00:00:00.000Z",
      "end" => "2015-06-17T23:59:59.999Z",
      "web" => "https://skillsmatter.com/conferences/6687-ioscon-2015-the-conference-for-ios-and-swift-developers",
      "cc:conference" => {
          "name" => "iOSCon"
      },
      "cc:city" => {
          "code" => "gblon",
          "name" => "London"
      },
      "cc:country" => {
          "code" => "gb",
          "name" => "United Kingdom"
      },
      "cc:continent" => {
          "code" => "eu"
      }
  }.to_json

  post '/events', body, { 'Content-Type' => 'application/json'}
end

Then(/^The Location Header should point to the Event$/) do
  data = JSON.parse(last_response.body)
  challenge_url = data['_links']['self']['href']
  expect(last_response.headers['Location']).to eq(challenge_url)
end


Given(/^The user isn't authenticated$/) do
  header "Authentication", nil
end

Given(/^There are (\d+) events of the same conference in the database$/) do |arg1|
  europe = Continent.create(:code => "eu", :name => "Europe")
  united_kingdom = Country.create(:code => "gb", :name => "United Kingdom", :continent => europe)
  london = City.create(:code => "gblon", :name => "London", :country => united_kingdom)
  ioscon = Conference.create(:name => "iOSCon", :web => "http://ioscon.com/")

  arg1.to_i.times do
    Event.create(
      :start => "2015-06-15T00:00:00.000Z",
      :end => "2015-06-17T23:59:59.999Z",
      :web => "https://skillsmatter.com/conferences/6687-ioscon-2015-the-conference-for-ios-and-swift-developers",
      :conference => ioscon,
      :city => london
    )
  end
end

Given(/^The iOSCon 2015 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  united_kingdom = Country.where(:code => "gb").first_or_create(:name => "United Kingdom", :continent => europe)
  london = City.where(:code => "gblon").first_or_create(:name => "London", :country => united_kingdom)
  ioscon = Conference.where(:name => "iOSCon").first_or_create()
  Event.create(
    :start => "2015-06-15T00:00:00.000Z",
    :end => "2015-06-17T23:59:59.999Z",
    :web => "https://skillsmatter.com/conferences/6687-ioscon-2015-the-conference-for-ios-and-swift-developers",
    :conference => ioscon,
    :city => london
  )
end

Given(/^The iOS Dev UK 2015 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  united_kingdom = Country.where(:code => "gb").first_or_create(:name => "United Kingdom", :continent => europe)
  aberystwyth = City.where(:code => "gbayw").first_or_create(:name => "Aberystwyth", :country => united_kingdom)
  iosdevuk = Conference.where(:name => "iOS Dev UK").first_or_create()
  Event.create(
    :start => "2015-09-07T00:00:00.000Z",
    :end => "2015-09-10T23:59:59.999Z",
    :web => "http://www.iosdevuk.com/",
    :conference => iosdevuk,
    :city => aberystwyth
  )
end

Given(/^The NSSpain 2015 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  spain = Country.where(:code => "es").first_or_create(:name => "Spain", :continent => europe)
  logrono = City.where(:code => "eslgr").first_or_create(:name => "Logroño", :country => spain)
  nsspain = Conference.where(:name => "NSSpain").first_or_create()
  Event.create(
    :start => "2015-09-15T00:00:00.000Z",
    :end => "2015-09-18T23:59:59.999Z",
    :web => "http://nsspain.com/2015/",
    :conference => nsspain,
    :city => logrono
  )
end

Given(/^The NSScotland 2015 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  united_kingdom = Country.where(:code => "gb").first_or_create(:name => "United Kingdom", :continent => europe)
  edinburgh = City.where(:code => "gbedi").first_or_create(:name => "Edinburgh", :country => united_kingdom)
  nsscotland = Conference.where(:name => "NSScotland").first_or_create()
  Event.create(
    :start => "2015-10-23T00:00:00.000Z",
    :end => "2015-10-25T23:59:59.999Z",
    :web => "http://nsscotland.com/",
    :conference => nsscotland,
    :city => edinburgh
  )
end

def check_event(actual_event, conference, event)
  event_city = event.city
  event_country = event_city.country
  event_continent = event_country.continent

  expect(actual_event["_links"]["self"]["href"]).to eq("/events/#{event.id}")

  expect(actual_event['start']).to eq(event.start.iso8601(3))
  expect(actual_event['end']).to eq(event.end.iso8601(3))
  expect(actual_event['web']).to eq(event.web)

  actual_conference = actual_event["_embedded"]["cc:conference"]
  expect(actual_conference["name"]).to eq(conference.name)
  expect(actual_conference["_links"]["self"]["href"]).to eq("/conferences/#{conference.id}")
  expect(actual_conference["_links"]["cc:event"]["href"]).to eq("/conferences/#{conference.id}/events")

  city = actual_event["cc:city"]
  expect(city["href"]).to eq("/cities/#{event_city.id}")
  expect(city["code"]).to eq(event_city.code)
  expect(city["name"]).to eq(event_city.name)

  country = actual_event["cc:country"]
  expect(country["href"]).to eq("/countries/#{event_country.id}")
  expect(country["code"]).to eq(event_country.code)
  expect(country["name"]).to eq(event_country.name)

  continent = actual_event["cc:continent"]
  expect(continent["href"]).to eq("/continents/#{event_continent.id}")
  expect(continent["code"]).to eq(event_continent.code)
  expect(continent["name"]).to eq(event_continent.name)
end

Then(/^The first event should be iOSCon 2015$/) do
  # fetch the actual data from database
  ioscon = Conference.where(:name => "iOSCon").first
  ioscon_2015 = ioscon.events.first

  # extract the actual event
  data = JSON.parse(last_response.body)
  events = data["_embedded"]["cc:event"]
  event = events[0]

  # make sure the data is correct
  check_event(event, ioscon, ioscon_2015)
end

Then(/^The second event should be iOS Dev UK 2015$/) do
  # fetch the actual data from database
  iosdevuk = Conference.where(:name => "iOS Dev UK").first
  iosdevuk_2015 = iosdevuk.events.first

  # extract the actual event
  data = JSON.parse(last_response.body)
  events = data["_embedded"]["cc:event"]
  event = events[1]

  # make sure the data is correct
  check_event(event, iosdevuk, iosdevuk_2015)
end

Then(/^The third event should be NSSpain 2015$/) do
  # fetch the actual data from database
  nsspain = Conference.where(:name => "NSSpain").first
  nsspain_2015 = nsspain.events.first

  # extract the actual event
  data = JSON.parse(last_response.body)
  events = data["_embedded"]["cc:event"]
  event = events[2]

  # make sure the data is correct
  check_event(event, nsspain, nsspain_2015)
end

Then(/^The fourth event should be NSScotland 2015$/) do
  # fetch the actual data from database
  nsscotland = Conference.where(:name => "NSScotland").first
  nsscotland_2015 = nsscotland.events.first

  # extract the actual event
  data = JSON.parse(last_response.body)
  events = data["_embedded"]["cc:event"]
  event = events[3]

  # make sure the data is correct
  check_event(event, nsscotland, nsscotland_2015)
end

When(/^The user fetches root$/) do
  get "/"
end

Then(/^There is a(?:n)? ([_a-z]+) Hash with (\d+) elements?$/) do |arg1,arg2|
  data = JSON.parse(last_response.body)
  expect(data[arg1]).not_to be_nil
  expect(data[arg1]).not_to be_empty
  expect(data[arg1].keys.length).to eq(arg2.to_i)
end

Then (/^There is a link to(?: the)? ([a-z]+) with an href of ([a-z\/]+)$/) do |arg1,arg2|
  data = JSON.parse(last_response.body)
  expect(data['_links'][arg1]).not_to be_nil
  expect(data['_links'][arg1]['href']).to eq(arg2)
end

When(/^The user sends a GET to \/events$/) do
  get "/events"
end

Then(/^There is an ([a-z:]+) List in the _embedded Hash$/) do |arg1|
  data = JSON.parse(last_response.body)
  expect(data['_embedded'][arg1]).to be_an(Array)
end

Then(/^There is are (\d+) elements in the ([a-z:]+) list$/) do |arg1,arg2|
  data = JSON.parse(last_response.body)
  expect(data['_embedded'][arg2].count).to eq(arg1.to_i)
end

Then(/^Every item in the list is a valid event$/) do
  data = JSON.parse(last_response.body)
  events = data['_embedded']['cc:event']

  events.each do |event|
    expect(event["_links"]).not_to be_nil
    expect(event["_links"].keys.length).to eq(1)
    expect(event["_links"]["self"]["href"]).to match(/\/events\/(\d+)/)
    expect(event["start"]).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
    expect(event["end"]).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
    expect(event["web"]).to match(/http(s?):\/\/[a-zA-Z.\/]+/)

    expect(event["_embedded"]).not_to be_nil

    conference = event["_embedded"]["cc:conference"]
    expect(conference).not_to be_nil
    expect(conference["_links"]).not_to be_nil
    expect(conference["_links"]["self"]).not_to be_nil
    expect(conference["_links"]["self"]["href"]).to match(/\/conferences\/(\d+)/)
    expect(conference["_links"]["cc:event"]["href"]).to match(/\/conferences\/(\d+)\/events/)
    expect(conference["name"]).not_to be_nil
    expect(conference["name"]).to be_a(String)

    city = event["cc:city"]
    expect(city).not_to be_nil
    expect(city["href"]).to match(/\/cities\/(\d+)/)
    expect(city["code"]).not_to be_nil
    expect(city["code"]).to be_a(String)
    expect(city["name"]).not_to be_nil
    expect(city["name"]).to be_a(String)

    country = event["cc:country"]
    expect(country).not_to be_nil
    expect(country["href"]).to match(/\/countries\/(\d+)/)
    expect(country["code"]).not_to be_nil
    expect(country["code"]).to be_a(String)
    expect(country["name"]).not_to be_nil
    expect(country["name"]).to be_a(String)

    continent = event["cc:continent"]
    expect(continent).not_to be_nil
    expect(continent["href"]).to match(/\/continents\/(\d+)/)
    expect(continent["code"]).not_to be_nil
    expect(continent["code"]).to be_a(String)
    expect(continent["name"]).not_to be_nil
    expect(continent["name"]).to be_a(String)
  end
end

When(/^The user fetches NSSpain 2015 event by ID$/) do
  # fetch the actual data from database
  nsspain = Conference.where(:name => "NSSpain").first
  nsspain_2015 = nsspain.events.first

  get "/events/#{nsspain_2015.id}"
end

When(/^The user fetches an event with some ID$/) do
  get "/events/0"
end

Then(/^The delivered event should be the NSSpain 2015$/) do
  # fetch the actual data from database
  nsspain = Conference.where(:name => "NSSpain").first
  nsspain_2015 = nsspain.events.first

  # extract the actual event
  data = JSON.parse(last_response.body)

  # make sure the data is correct
  check_event(data, nsspain, nsspain_2015)
end

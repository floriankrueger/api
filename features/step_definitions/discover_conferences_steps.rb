
When(/^The user sends a GET to \/conferences$/) do
  get "/conferences"
end

Then(/^Every item in the list is a valid conference$/) do
  data = JSON.parse(last_response.body)
  conferences = data['_embedded']['cc:conference']

  conferences.each do |conference|
    expect(conference["_links"]).not_to be_nil
    expect(conference["_links"].keys.length).to eq(2)
    expect(conference["_links"]["self"]["href"]).to match(/\/conferences\/(\d+)/)
    expect(conference["_links"]["cc:event"]["href"]).to match(/\/conferences\/(\d+)\/events/)

    expect(conference["name"]).not_to be_nil
    expect(conference["web"]).not_to be_nil
    expect(conference["web"]).to match(/http(s?):\/\/[a-zA-Z.\/]+/)
  end
end

Given(/^The iOSCon 2014 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  united_kingdom = Country.where(:code => "gb").first_or_create(:name => "United Kingdom", :continent => europe)
  london = City.where(:code => "gblon").first_or_create(:name => "London", :country => united_kingdom)
  ioscon = Conference.where(:name => "iOSCon").first_or_create()
  Event.create(
    :start => "2014-05-15T00:00:00.000Z",
    :end => "2014-05-16T23:59:59.999Z",
    :web => "https://skillsmatter.com/conferences/1984-ioscon-2014",
    :conference => ioscon,
    :city => london
  )
end

Given(/^The iOS Dev UK 2014 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  united_kingdom = Country.where(:code => "gb").first_or_create(:name => "United Kingdom", :continent => europe)
  aberystwyth = City.where(:code => "gbayw").first_or_create(:name => "Aberystwyth", :country => united_kingdom)
  iosdevuk = Conference.where(:name => "iOS Dev UK").first_or_create()
  Event.create(
    :start => "2014-09-02T00:00:00.000Z",
    :end => "2014-09-04T23:59:59.999Z",
    :web => "http://www.iosdevuk.com/",
    :conference => iosdevuk,
    :city => aberystwyth
  )
end

Given(/^The NSSpain 2014 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  spain = Country.where(:code => "es").first_or_create(:name => "Spain", :continent => europe)
  logrono = City.where(:code => "eslgr").first_or_create(:name => "Logroño", :country => spain)
  nsspain = Conference.where(:name => "NSSpain").first_or_create()
  Event.create(
    :start => "2014-09-17T00:00:00.000Z",
    :end => "2014-09-19T23:59:59.999Z",
    :web => "http://nsspain.com/2014/",
    :conference => nsspain,
    :city => logrono
  )
end

Given(/^The NSScotland 2014 event is in the database$/) do
  europe = Continent.where(:code => "eu").first_or_create(:name => "Europe")
  united_kingdom = Country.where(:code => "gb").first_or_create(:name => "United Kingdom", :continent => europe)
  edinburgh = City.where(:code => "gbedi").first_or_create(:name => "Edinburgh", :country => united_kingdom)
  nsscotland = Conference.where(:name => "NSScotland").first_or_create()
  Event.create(
    :start => "2014-10-25T00:00:00.000Z",
    :end => "2014-10-26T23:59:59.999Z",
    :web => "http://nsscotland.com/",
    :conference => nsscotland,
    :city => edinburgh
  )
end

def check_conference(actual_conference, conference)
  expect(actual_conference["_links"]).not_to be_nil
  expect(actual_conference["_links"].keys.length).to eq(2)
  expect(actual_conference["_links"]["self"]["href"]).to eq("/conferences/#{conference.id}")
  expect(actual_conference["_links"]["cc:event"]["href"]).to eq("/conferences/#{conference.id}/events")

  expect(actual_conference["name"]).to eq(conference.name)
  expect(actual_conference["web"]).to eq(conference.web)
end

Then(/^The first conference should be iOSCon$/) do
  # fetch the actual data from database
  ioscon = Conference.where(:name => "iOSCon").first

  # extract the actual conference
  data = JSON.parse(last_response.body)
  conferences = data["_embedded"]["cc:conference"]
  conference = conferences[0]

  # make sure the data is correct
  check_conference(conference, ioscon)
end

Then(/^The second conference should be iOS Dev UK$/) do
  # fetch the actual data from database
  iosdevuk = Conference.where(:name => "iOS Dev UK").first

  # extract the actual conference
  data = JSON.parse(last_response.body)
  conferences = data["_embedded"]["cc:conference"]
  conference = conferences[1]

  # make sure the data is correct
  check_conference(conference, iosdevuk)
end

Then(/^The third conference should be NSSpain$/) do
  # fetch the actual data from database
  nsspain = Conference.where(:name => "NSSpain").first

  # extract the actual conference
  data = JSON.parse(last_response.body)
  conferences = data["_embedded"]["cc:conference"]
  conference = conferences[2]

  # make sure the data is correct
  check_conference(conference, nsspain)
end

Then(/^The fourth conference should be NSScotland$/) do
  # fetch the actual data from database
  nsscotland = Conference.where(:name => "NSScotland").first

  # extract the actual conference
  data = JSON.parse(last_response.body)
  conferences = data["_embedded"]["cc:conference"]
  conference = conferences[3]

  # make sure the data is correct
  check_conference(conference, nsscotland)
end

When(/^The user fetches NSSpain conference by ID$/) do
  nsspain = Conference.where(:name => "NSSpain").first
  get "/conferences/#{nsspain.id}"
end

Then(/^The delivered conference should be the NSSpain$/) do
  # fetch the actual data from database
  nsspain = Conference.where(:name => "NSSpain").first

  # extract the actual conference
  conference = JSON.parse(last_response.body)

  # make sure the data is correct
  check_conference(conference, nsspain)
end

When(/^The user fetches a conference with some ID$/) do
  get "/conferences/0"
end

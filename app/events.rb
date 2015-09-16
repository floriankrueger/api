
post "/events/?" do
  unless @session
    raise AuthenticationFailed, "Please log in to create Events"
  end

  body = JSON.parse request.body.read

  # find the continent
  continent_data = body['cc:continent']
  raise EventValidationError, "Provide continent information!" unless continent_data
  continent = Continent.find_by_code(code: continent_data['code'])

  # find or create the country
  country_data = body['cc:country']
  raise EventValidationError, "Provide country information!" unless country_data
  country = Country.find_by_code_or_create(code: country_data['code'], name: country_data['name'])

  # find or create the city
  city_data = body['cc:city']
  raise EventValidationError, "Provide city information!" unless city_data
  city = City.find_by_code_or_create(code: city_data['code'], name: city_data['name'])

  # find or create the conference
  conference_data = body['cc:conference']
  raise EventValidationError, "Provide conference information!" unless conference_data
  conference = Conference.find_by_name_or_create(name: conference_data['name'])

  # create the event
  event = Event.new(
    :start => body['start'],
    :end => body['end'],
    :web => body['web']
  )
  raise EventValidationError, "Invalid event information!" unless event.valid?

  # save the data
  if country.new_record?
    country.continent = continent
    country.save
  end

  if city.new_record?
    city.country = country
    city.save
  end

  if conference.new_record?
    conference.save
  end

  event.conference = conference
  event.city = city
  event.save

  status 201
  content_type "application/hal+json"

  event_location = "/events/#{event.id}"

  headers \
    "Location" => event_location
  {
    "_links" => {
        "self" => { "href": event_location }
    }
  }.to_json
end

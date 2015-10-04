
get "/continents/?" do
  continents = Continent.all.collect do |continent|
    continent.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => "/continents" } },
    :_embedded => {
      "cc:continent" => continents
    }
  }.to_json
end

get "/continents/:continent_code/?" do
  continent = continent_with_code(code: params[:continent_code])

  status 200
  content_type "application/hal+json"
  continent.embedded_format.to_json
end

get "/continents/:continent_code/countries/?" do
  continent = continent_with_code(code: params[:continent_code])

  countries = continent.countries.collect do |country|
    country.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => continent.href_countries } },
    :_embedded => {
      "cc:country" => countries
    }
  }.to_json
end

get "/continents/:continent_code/events/?" do
  continent = continent_with_code(code: params[:continent_code])

  events = continent.events.collect do |event|
    event.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => continent.href_events } },
    :_embedded => {
      "cc:event" => events
    }
  }.to_json
end

def continent_with_code(code:)
  continent = Continent.where(:code => code).first

  unless continent
    raise NotFoundError, "There is no continent with the code #{code}."
  end

  return continent
end

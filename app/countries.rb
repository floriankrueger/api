
get "/countries/?" do
  countries = Country.all.order(name: :asc).collect do |country|
    country.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => "/countries" } },
    :_embedded => {
      "cc:country" => countries
    }
  }.to_json
end

get "/countries/:country_code/?" do
  country = country_with_code(code: params[:country_code])

  status 200
  content_type "application/hal+json"
  country.embedded_format.to_json
end

get "/countries/:country_code/cities/?" do
  country = country_with_code(code: params[:country_code])
  cities = country.cities.order(name: :asc).collect do |city|
    city.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => "/countries/#{country.code}/cities" } },
    :_embedded => {
      "cc:city" => cities
    }
  }.to_json
end

get "/countries/:country_code/events/?" do
  country = country_with_code(code: params[:country_code])
  events = country.events.order(start: :desc).collect do |event|
    event.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => "/countries/#{country.code}/events" } },
    :_embedded => {
      "cc:event" => events
    }
  }.to_json
end

def country_with_code(code:)
  country = Country.where(:code => code).first

  unless country
    raise NotFoundError, "There is no country with the code #{code}."
  end

  return country
end

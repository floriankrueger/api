
get "/cities/?" do
  cities = City.all.order(name: :asc).collect do |city|
    city.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => "/cities" } },
    :_embedded => {
      "cc:city" => cities
    }
  }.to_json
end

get "/cities/:city_code/?" do
  city = city_with_code(code: params[:city_code])

  status 200
  content_type "application/hal+json"
  city.embedded_format.to_json
end

get "/cities/:city_code/events/?" do
  city = city_with_code(code: params[:city_code])
  events = city.events.order(start: :desc).collect do |event|
    event.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { :self => { :href => city.events_href } },
    :_embedded => {
      "cc:event" => events
    }
  }.to_json
end

def city_with_code(code:)
  city = City.where(:code => code).first

  unless city
    raise NotFoundError, "There is no city with the code #{code}."
  end

  return city
end


get "/conferences/?" do
  conferences = Conference.all.order(created_at: :desc).collect do |conference|
    conference.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { "self" => { "href" => "/conferences" } },
    :_embedded => {
      "cc:conference" => conferences
    }
  }.to_json
end

get "/conferences/:conference_id/?" do
  conference = Conference.find(params[:conference_id].to_i)

  status 200
  content_type "application/hal+json"
  conference.embedded_format.to_json
end

get "/conferences/:conference_id/events" do
  conference = Conference.find(params[:conference_id].to_i)
  events = conference.events.order(start: :desc).collect do |event|
    event.embedded_format
  end

  status 200
  content_type "application/hal+json"
  {
    :_links => { "self" => { "href" => "/conferences/#{params[:conference_id]}/events" } },
    :_embedded => {
      "cc:event" => events
    }
  }.to_json
end

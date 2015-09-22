
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

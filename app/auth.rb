
post "/auth/challenges/?" do
  supported_methods = ['pin']
  unless supported_methods.include? params[:method]
    raise ArgumentError, "Please supply a valid authentication method. Supported methods are: #{supported_methods.join(', ')}"
  end

  client = TwitterClient.instance
  challenge = client.create_challenge(method: params[:method])

  status 201
  content_type "application/hal+json"
  headers \
    "Location" => challenge.location
  challenge.to_json
end

post "/auth/challenges/:challenge_id" do
  client = TwitterClient.instance
  challenge = client.get_challenge(challenge_id: params[:challenge_id])
  body = JSON.parse request.body.read
  session_info = client.fullfill_challenge(challenge: challenge, params: body)

  status 200
  content_type "application/hal+json"
  {
    :session_token => session_info[:session_token],
    :session_secret => session_info[:session_secret]
  }.to_json
end

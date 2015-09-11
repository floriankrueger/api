
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

  # fulfill challenge and create user session
  challenge = client.get_challenge(challenge_id: params[:challenge_id])
  body = JSON.parse request.body.read
  session_info = client.fullfill_challenge(challenge: challenge, params: body)
  current_session = session_info[:session]

  # fetch user information from twitter for the current session
  user = client.fetch_user_info(session: current_session)
  link_to_user = "/users/#{user.screen_name}"

  if user.new_record?
    status 201
    headers \
      "Location" => link_to_user
  else
    status 200
  end

  user.save

  content_type "application/hal+json"
  {
    :_links => {
      :user => { :href => link_to_user }
    },
    :session_token => session_info[:session_token],
    :session_secret => session_info[:session_secret]
  }.to_json
end


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
  challenge = client.get_challenge(params[:challenge_id])


end

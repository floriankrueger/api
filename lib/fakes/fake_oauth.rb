
class FakeRequestToken
  attr_accessor :token, :secret, :authorize_url
  def initialize(token, secret, authorize_url)
    @token = token
    @secret = secret
    @authorize_url = authorize_url
  end
end

class FakeOAuth
  attr_reader :last_params
  attr_reader :request_token

  def initialize()
    @last_params = nil
    @request_token = FakeRequestToken.new( "a_token", "a_secret", "http://example.org" )
  end

  def get_request_token(params)
    @last_params = params
    @request_token
  end
end

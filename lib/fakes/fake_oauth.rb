
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
  attr_reader :access_token

  def initialize()
    @last_params = nil
    @request_token = FakeRequestToken.new( "a_token", "a_secret", "http://example.org" )
    @access_token = { :oauth_token => "an_access_token", :oauth_token_secret => "an_access_token_secret" }
  end

  def http_method
    "FAKE"
  end

  def access_token_url?
    true
  end

  def access_token_url
    "http://example.org"
  end

  def token_request(http_method, path, token = nil, request_options = {}, *arguments)
    @last_params = request_options
    @access_token
  end

  def get_request_token(params)
    @last_params = params
    @request_token
  end
end

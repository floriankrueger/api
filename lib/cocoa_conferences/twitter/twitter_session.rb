require 'securerandom'

class TwitterSession

  attr_reader :session_token, :token, :secret

  def self.create(token:, secret:)
    TwitterSession.new(
      session_token: SecureRandom.urlsafe_base64,
      token: token,
      secret: secret)
  end

  def initialize(session_token:, token:, secret:)
    unless session_token == nil || token == nil || secret == nil
      @session_token = session_token
      @token = token
      @secret = secret
    else
      raise ArgumentError, "None of the parameters are optional."
    end
  end

  def to_store_format()
    { :token => @token, :secret => @secret }.to_json
  end

  def self.from_store_format(session_token:, store_format:)
    begin
      raw = JSON.parse(store_format)
      TwitterSession.new(
        session_token: session_token,
        token: raw['token'],
        secret: raw['secret'])
    rescue
      raise InternalServerError, "The Session is invalid. Please start over."
    end
  end

end

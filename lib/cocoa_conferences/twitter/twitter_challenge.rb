
require 'securerandom'

class TwitterChallenge

  attr_reader :challenge_token

  def self.create(method:, request_token:, challenge_token: SecureRandom.urlsafe_base64)
    TwitterChallenge.new(
      method: method,
      twitter_url: request_token.authorize_url,
      twitter_token: request_token.token,
      twitter_secret: request_token.secret,
      challenge_token: challenge_token)
  end

  def initialize(method:, twitter_url:, twitter_token:, twitter_secret:, challenge_token:)
    unless method == nil || twitter_url == nil || twitter_token == nil || twitter_secret == nil || challenge_token == nil
      @method = method
      @challenge_token = challenge_token
      @challenge_url = "/auth/challenges/#{challenge_token}"
      @twitter_url = twitter_url
      @twitter_token = twitter_token
      @twitter_secret = twitter_secret
    else
      raise ArgumentError, "None of the parameters are optional."
    end
  end

  def location
    @challenge_url
  end

  def to_store_format
    { :method => @method, :external_auth_url => @twitter_url, :token => @twitter_token, :secret => @twitter_secret }.to_json
  end

  def self.from_store_format(challenge_token:, store_format:)
    begin
      raw = JSON.parse(store_format)
      TwitterChallenge.new(
        method: raw['method'],
        twitter_url: raw['external_auth_url'],
        twitter_token: raw['token'],
        twitter_secret: raw['secret'],
        challenge_token: challenge_token)
    rescue
      raise InternalServerError, "The Challenge is invalid. Please start over."
    end
  end

  def as_json(options = {})
    {
      "_links" => { "self" => { "href" => @challenge_url } },
      "external_auth_url" => @twitter_url
    }
  end

end

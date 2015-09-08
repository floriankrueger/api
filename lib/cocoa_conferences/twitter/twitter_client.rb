require 'securerandom'

class TwitterClient
  include Singleton

  attr_accessor :consumer
  attr_accessor :store
  attr_accessor :challenge_expiry

  def initialize()
    @consumer_key = ENV['TWITTER_CONSUMER_KEY']
    @consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    @challenge_expiry = 300
    @consumer = nil
  end

  def create_challenge(method:)
    consumer = self.current_consumer()
    store = self.current_store()

    case method
    when 'pin'
      request_token = consumer.get_request_token(:oauth_callback => "oob")
      challenge_token = SecureRandom.urlsafe_base64
      token = request_token.token
      secret = request_token.secret
      store.set(challenge_token, { :token => token, :secret => secret }.to_json, { :ex => @challenge_expiry })
      return TwitterChallenge.new(challenge_token: challenge_token, twitter_url: request_token.authorize_url)
    else
      raise InternalServerError, "Couldn't handle method #{method}. Please try again later."
    end
  end

  def current_consumer()
    unless @consumer
      @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {
                     :site               => 'https://api.twitter.com',
                     :request_token_path => '/oauth/request_token',
                     :authorize_path     => '/oauth/authorize',
                     :access_token_path  => '/oauth/access_token' })
    end
    @consumer
  end

  def current_store()
    unless @store
      @store = Redis.new(url: ENV["REDIS_URL"])
    end
    @store
  end

end

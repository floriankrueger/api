
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
      challenge = TwitterChallenge.create(method: method, request_token: request_token)
      store.set(challenge.challenge_token, challenge.to_store_format, { :ex => @challenge_expiry })
      return challenge
    else
      raise InternalServerError, "Couldn't handle method #{method}. Please try again later."
    end
  end

  def get_challenge(challenge_id:)
    unless challenge_id.is_a? String
      raise ArgumentError, "Invalid Challenge ID"
    end

    store = self.current_store()
    raw_challenge = store.get(challenge_id)

    unless raw_challenge
      raise ArgumentError, "Unknown Challenge ID. The Challenge might have expired."
    end

    challenge = JSON.parse(raw_challenge)


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


require 'openssl'

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
    @store = nil
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
      raise ArgumentError, "Invalid Challenge ID."
    end

    store = self.current_store()
    raw_challenge = store.get(challenge_id)

    unless raw_challenge
      raise NotFoundError, "Unknown Challenge ID. The Challenge might have expired."
    end

    TwitterChallenge.from_store_format(challenge_token: challenge_id, store_format: raw_challenge)
  end

  def fullfill_challenge(challenge:, params:)
    case challenge.method
    when 'pin'
      unless params['pin'].is_a? String
        raise ArgumentError, "Insufficient Data. To fulfill a PIN Challenge you need to provide a {'pin':'<some_pin>'}"
      end

      fullfill_pin_challenge(challenge: challenge, pin: params['pin'])
    end
  end

  def fullfill_pin_challenge(challenge:, pin:)
    consumer = current_consumer()
    request_token = OAuth::RequestToken.new(consumer, challenge.twitter_token, challenge.twitter_secret)
    access_token = request_token.get_access_token(:oauth_verifier => pin)
    create_session(token: access_token.token, secret: access_token.secret)
  end

  def create_session(token:, secret:)
    store = self.current_store()

    unless token.is_a? String
      raise ArgumentError, "Invalid OAuth Access Token"
    end

    unless secret.is_a? String
      raise ArgumentError, "Invalid OAuth Access Token Secret"
    end

    session = TwitterSession.create(token: token, secret: secret)
    encryption_info = encrypt_session(plain_store_format: session.to_store_format, master_key: ENV['SESSION_MASTER_KEY'])
    store.set(session.session_token, { :data => encryption_info[:data], :iv => encryption_info[:iv] }.to_json)
    { :session_token => session.session_token, :session_secret => encryption_info[:key] }
  end

  def get_session(session_token:, session_secret:)
    # TODO
  end

  def encrypt_session(plain_store_format:, master_key:)
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = master_key
    inner_iv = cipher.random_iv
    inner_encrypted = cipher.update(plain_store_format) + cipher.final

    inner_data = {
      :data => utf8_encode(inner_encrypted),
      :iv => utf8_encode(inner_iv)
    }.to_json

    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    outer_key = cipher.random_key
    outer_iv = cipher.random_iv
    outer_encrypted = cipher.update(inner_data) + cipher.final

    {
      :data => utf8_encode(outer_encrypted),
      :key => utf8_encode(outer_key),
      :iv => utf8_encode(outer_iv)
    }
  end

  def utf8_encode(string)
    Base64.encode64(string).encode('utf-8')
  end

  def utf8_decode(string)
    Base64.decode64(string).encode('ascii-8bit')
  end

  def decrypt_session(encrypted_store_format:, master_key:, key:, iv:)

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

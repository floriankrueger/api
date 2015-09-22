
require 'openssl'
require 'redis'

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
    { :session_token => session.session_token, :session_secret => encryption_info[:key], :session => session }
  end

  def get_session(session_token:, session_secret:)
    store = self.current_store()
    encrypted_session_info_raw = store.get(session_token)

    unless encrypted_session_info_raw
      raise AuthenticationFailed, "Invalid Session. Maybe it expired. Please login again."
    end

    encrypted_session_info = JSON.parse(encrypted_session_info_raw)

    unless encrypted_session_info
      raise AuthenticationFailed, "Invalid Session. Maybe it expired. Please login again."
    end

    decrypted_session_store_format = decrypt_session(
      encrypted_store_format: encrypted_session_info['data'],
      master_key: ENV['SESSION_MASTER_KEY'],
      key: session_secret,
      iv: encrypted_session_info['iv'])

    TwitterSession.from_store_format(session_token: session_token, store_format: decrypted_session_store_format)
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

  def decrypt_session(encrypted_store_format:, master_key:, key:, iv:)
    begin
      decipher = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.key = utf8_decode(key)
      decipher.iv = utf8_decode(iv)

      outer_encrypted = utf8_decode(encrypted_store_format)

      inner_data_raw = decipher.update(outer_encrypted) + decipher.final
      inner_data = JSON.parse(inner_data_raw)

      decipher = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.key = master_key
      decipher.iv = utf8_decode(inner_data['iv'])

      decipher.update(utf8_decode(inner_data['data'])) + decipher.final
    rescue Exception => e
      raise AuthenticationFailed, "Invalid Session. Maybe it expired. Please login again."
    end
  end

  def fetch_user_info(session:)
    unless session.is_a? TwitterSession
      raise ArgumentError, "Invalid Session"
    end

    consumer = self.current_consumer()
    access_token = OAuth::AccessToken.new(consumer, session.token, session.secret)

    response = access_token.get('/1.1/account/verify_credentials.json')
    user_info = JSON.parse(response.body)
    User.create_or_update_with_twitter_info(user_info: user_info)
  end

  def utf8_encode(string)
    Base64.encode64(string).encode('utf-8')
  end

  def utf8_decode(string)
    Base64.decode64(string).encode('ascii-8bit')
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

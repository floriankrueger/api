
class AuthHeader

  attr_reader :scheme, :token, :secret

  VALID_SCHEMES = ['CC-AUTH']

  def initialize(header_string:)
    elements = header_string.split(/ /).collect { |e| e.strip }
    @scheme = elements.shift

    unless VALID_SCHEMES.include? @scheme
      raise AuthenticationFailed, "Invalid authentication scheme."
    end

    args = {}
    elements.each do |element|
      match = element.match(/([a-z]+)\=\"(.+\n?)\",?/)
      if match
        args[match[1]] = match[2]
      end
    end

    @token = args['token']
    @secret = args['secret']

    unless @token
      raise AuthenticationFailed, "Token is missing."
    end

    unless @secret
      raise AuthenticationFailed, "Secret is missing."
    end
  end

end

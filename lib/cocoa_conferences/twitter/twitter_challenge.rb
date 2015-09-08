
class TwitterChallenge

  attr_reader :twitter_url

  def initialize(challenge_token:, twitter_url:)
    @challenge_token = challenge_token
    @twitter_url = twitter_url
  end

  def challenge_url
    "/auth/challenges/#{@challenge_token}"
  end

end

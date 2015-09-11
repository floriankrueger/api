
class FakeRedis

  attr_reader :store
  attr_reader :options

  def initialize()
    @store = {}
    @options = {}
  end

  def set(key, value, options = {})
    @store[key] = value
    @options[key] = options
  end

  def get(key)
    @store[key]
  end

end

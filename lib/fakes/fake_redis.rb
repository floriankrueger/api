
class FakeRedis

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

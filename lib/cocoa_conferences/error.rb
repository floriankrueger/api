
class Error

  attr_reader :message, :info

  def initialize(message:, info: {})
    @message = message
    @info = info
  end

  def as_json(options = {})
    {
      "error" => {
        "message" => @message,
        "info" => @info
      }
    }
  end
end

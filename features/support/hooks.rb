
Around do |scenario, block|
  ActiveRecord::Base.connection.transaction do
    block.call
    raise ActiveRecord::Rollback
  end
end

After do |scenario|
  # reset oauth + redis
  TwitterClient.instance.consumer = nil
  TwitterClient.instance.store = nil
end

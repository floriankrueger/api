
Around do |scenario, block|
  ActiveRecord::Base.connection.transaction do
    block.call
    raise ActiveRecord::Rollback
  end
end

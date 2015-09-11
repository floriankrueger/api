
class User < ActiveRecord::Base
  def self.create_or_update_with_twitter_info(user_info:)
    User
      .where(:external_id => user_info['id_str'])
      .first_or_initialize(
        :name => user_info['name'],
        :screen_name => user_info['screen_name'],
        :location => user_info['location'],
        :description => user_info['description'],
        :profile_image_url => user_info['profile_image_url'],
        :expanded_url => user_info['expanded_url'],
        :domain => 'twitter'
      )
  end
end

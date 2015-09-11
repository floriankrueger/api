class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :name
      t.string :screen_name
      t.string :location
      t.string :description
      t.string :profile_image_url
      t.string :expanded_url
      t.string :domain
      t.string :external_id
    end
  end
end

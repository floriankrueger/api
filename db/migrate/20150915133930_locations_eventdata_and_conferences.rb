class LocationsEventdataAndConferences < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.belongs_to :conference, index: true
      t.belongs_to :city, index: true
    end

    create_table :conferences do |t|
      t.timestamps null: false
      t.string :name
    end

    create_table :continents do |t|
      t.timestamps null: false
      t.string :name
      t.string :code, index: true
    end

    create_table :countries do |t|
      t.belongs_to :continent, index: true
      t.timestamps null: false
      t.string :name
      t.string :code, index: true
    end

    create_table :cities do |t|
      t.belongs_to :country, index: true
      t.timestamps null: false
      t.string :name
      t.string :code, index: true
    end
  end
end

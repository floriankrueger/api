class LocationsEventdataAndConferences < ActiveRecord::Migration
  def change
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
      t.timestamps null: false
      t.string :name
      t.string :code, index: true
    end

    create_table :cities do |t|
      t.timestamps null: false
      t.string :name
      t.string :code, index: true
    end
  end
end

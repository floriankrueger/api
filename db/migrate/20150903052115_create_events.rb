class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps null: false
      t.datetime :start
      t.datetime :end
      t.string :web
    end
  end
end

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps null: false
      t.date :start
      t.date :end
      t.string :web
    end
  end
end

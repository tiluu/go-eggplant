class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string      :name
      t.string      :password
      t.string      :location
      t.datetime    :start_date
      t.datetime    :end_date

      t.timestamps null: false
    end
  end
end

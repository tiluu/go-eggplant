class CreateTravelGroup < ActiveRecord::Migration
  def change
    create_table :travel_groups do |t|
        t.belongs_to :user, index: true
        t.belongs_to :trip, index: true
    end
  end
end

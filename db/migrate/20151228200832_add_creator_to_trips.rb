class AddCreatorToTrips < ActiveRecord::Migration
  def change
      add_column :trips, :creator, :integer
      
  end
end

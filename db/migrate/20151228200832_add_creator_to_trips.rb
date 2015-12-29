class AddCreatorToTrips < ActiveRecord::Migration
  def change
      add_column :trips, :creator, :integer
      remove_column :users, :role, :string
  end
end

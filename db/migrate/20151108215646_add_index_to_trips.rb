class AddIndexToTrips < ActiveRecord::Migration
  def change
      add_reference :trips, :user, index: true, foreign_key:true
      remove_reference :users, :trip, index: true
  end
end

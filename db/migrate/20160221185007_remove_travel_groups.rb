class RemoveTravelGroups < ActiveRecord::Migration
  def change
    drop_table :travel_groups
  end
end

class RemovePasswordFieldFromTrip < ActiveRecord::Migration
  def change
    remove_column :trips, :password, :string
  end
end

class AddStatusToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :ended?, :boolean

    Trip.all.each do |trip|
        if Date.today > trip.end_date
            trip.update_attribute(:ended?, true)
        end
    end
  end
end

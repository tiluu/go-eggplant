class TravelGroup < ActiveRecord::Base

    belongs_to :users
    belongs_to :trips
end

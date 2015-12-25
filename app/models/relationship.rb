class Relationship < ActiveRecord::Base
    belongs_to :friend, class_name: "User"
    belongs_to :group_trip, class_name: "Trip"
    validates :email,:group_trip_id, presence: true
    
end

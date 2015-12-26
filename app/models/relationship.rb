class Relationship < ActiveRecord::Base
    include ValidEmails

    belongs_to :friend, class_name: "User"
    belongs_to :group_trip, class_name: "Trip"
    
    validates :email,:group_trip_id, presence: true
    validates_uniqueness_of :email, scope: :group_trip_id, message: "%{value}: This person has already been invited"
end 

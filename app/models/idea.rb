class Idea < ActiveRecord::Base
    include ValidDates

    belongs_to :user
    belongs_to :trip
    belongs_to :group_trips, class_name: Trip
    belongs_to :idea_category

    validates :title, presence: true 
end

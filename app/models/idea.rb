class Idea < ActiveRecord::Base
    include ValidDates

    belongs_to :user
    belongs_to :trip
    validates :trip_id, presence: true
    #validates :title, presence: true
    
  
end

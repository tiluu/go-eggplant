class Idea < ActiveRecord::Base
    include ValidDates

    #belongs_to :user
    belongs_to :trip
    
    validates :title, presence: true
    
  
end

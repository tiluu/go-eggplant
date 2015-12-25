class Trip < ActiveRecord::Base
    include ValidDates
    belongs_to :user
    has_many :relationships, foreign_key: "group_trip_id",
                       dependent: :destroy
    has_many :friends, through: :relationships   
    
    has_many :ideas, dependent: :destroy
    #accepts_nested_attributes_for :ideas

    validates :name, :city, :country, 
              :state_or_province, presence: true
    
    validates :name, length: { maximum: 50 }

    
   end

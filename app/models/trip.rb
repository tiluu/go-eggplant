class Trip < ActiveRecord::Base
    has_many :users, dependent: :destroy
    accepts_nested_attributes_for :users

    validates :name, :password, :password_confirmation, :city, 
              :country, :state_or_province, presence: true
    
    validates :name, length: { maximum: 50 }
    validates :password, confirmation: true,
                         length: { in: 6..15 }
    
    validate :start_date_not_in_past, on: :create
    validate :end_date_not_in_past
    

    def start_date_not_in_past
        if start_date < Date.today 
            errors.add(:start_date, "can't be in the past")
        end
    end

    def end_date_not_in_past
        if end_date < start_date + 1
            errors.add(:end_date, "can't end earlier than trip start date") 
        end
    end


end

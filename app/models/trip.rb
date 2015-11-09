class Trip < ActiveRecord::Base
    belongs_to :user

    validates :name, :password, :password_confirmation, :city, 
              :country, :state_or_province, presence: true
    
    validates :name, length: { maximum: 50 }
    
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

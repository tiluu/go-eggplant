class Trip < ActiveRecord::Base
    belongs_to :user

    validates :name, :city, :country, 
              :state_or_province, presence: true
    
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

    def as_json(options={})
        super(:only => [:start_date, :end_date],
              :methods => [:start_d, :end_d])
    end
    
    def format_date(date)
        date.nil? ? "" : date.strftime("%a %b %d %Y")
    end
    def start_d
        format_date(self.start_date)
    end

    def end_d
        format_date(self.end_date)
    end

end

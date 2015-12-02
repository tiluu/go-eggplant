module ValidDates
    extend ActiveSupport::Concern
    included do
        validate :start_date_not_in_past, on: :create
        validate :end_date_not_in_past
    end

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

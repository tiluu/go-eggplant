module ApplicationHelper
   
    def getPath(ctrl, action)
      {controller: ctrl, action: action}   
    end

    def format_time(time)
        time.nil? ? "" : time.strftime("%I: %M %p")    
    end

    def start_t
        format_time(@idea.start_time)
    end

    def end_t
        format_time(@idea.end_time)
    end

    def format_date(date)
       date.nil? ? "n/a" : date.strftime("%a %b %d, %Y")
    end
    
    def start_d
        format_date(@trip.start_date)
    end

    def end_d
        format_date(@trip.end_date)
    end
      
end

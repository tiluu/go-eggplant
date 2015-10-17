module ApplicationHelper
    def format_date(date)
       date.nil? ? "" : date.strftime("%a %b %d, %Y")
    end

   end

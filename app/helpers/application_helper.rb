module ApplicationHelper
    def format_date(date)
       date.nil? ? "" : date.strftime("%a %b %d, %Y")
    end
    
    def yelp_api(location, terms, limit, radius=5000) 
        begin
            @result = Yelp.client.search(location, {term: terms, limit: limit, radius_filter: radius})
        rescue Yelp::Error::UnavailableForLocation => e
            @yelp_error = "No results available for #{location}"
        end
    end
   end

module ApplicationHelper
   
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
       date.nil? ? "" : date.strftime("%a %b %d, %Y")
    end
    
    def start_d
        format_date(@trip.start_date)
    end

    def end_d
        format_date(@trip.end_date)
    end
    
    def yelp_api(location, terms, sort=0, category='', offset=0, limit=15, radius=5000) 
        begin
            @result = Yelp.client.search(location, 
                                         {term: terms,
                                          limit: limit,
                                          sort: sort,
                                          offset: offset,
                                          radius_filter: radius,
                                          category_filter: category })
        rescue Yelp::Error::UnavailableForLocation => e
            @yelp_error = "No results available for #{location}"
        end
    end

      
   end

module ApplicationHelper
    def format_date(date)
       date.nil? ? "" : date.strftime("%a %b %d, %Y")
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

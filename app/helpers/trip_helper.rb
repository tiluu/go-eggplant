module TripHelper
    def getTrip(invite)
        Trip.find(invite.trip_id)
    end

    def creator(trip)
        User.find(trip.creator)
    end

    def trip_countdown
        days_left = ( (@trip.start_date - Time.now)/86400 ).ceil
        trip_duration = -( (@trip.end_date - @trip.start_date)/86400 ).ceil
        count = pluralize(days_left, 'day')

        countdown = "Starts in #{count}"
       
        if days_left === 1
        	countdown = "Starts tomorrow!"
        elsif days_left < 0 && days_left > trip_duration
        	days_left = ( (Time.now - @trip.start_date)/86400 ).ceil
        	countdown = "Started #{count} ago"
        elsif days_left < trip_duration
        	days_left = ( (Time.now - @trip.end_date)/86400 ).ceil
        	countdown = "Ended #{count} ago"
        end
        countdown
    end

    def headcount(trip)
        count = 0
        trip.invites.each do |invite|
            if invite.going?
                count+= 1
            end
        end
        pluralize(count, 'person')
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

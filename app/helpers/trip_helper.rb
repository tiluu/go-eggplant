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
        count = pluralize(days_left.abs, 'day')

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
end

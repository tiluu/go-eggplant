module TripHelper
    def getTrip(invite)
        Trip.find(invite.trip_id)
    end

    def getInvite(trip)
        Relationship.where(trip_id: trip.id, user_id: current_user.id).first
    end

    def tripEnded?(trip)
        Date.today > trip.end_date
    end

    def creator(trip)
        User.find(trip.creator)
    end

    def creator?(invite=nil, trip=nil)
        if invite
            creator( getTrip(invite) ) == current_user 
        else
            creator(trip) == current_user 
        end
    end

    def getRSVP(invite)
        if invite.rsvped?
            invite.going? && !invite.maybe? ? "GOING" : "MAYBE"
        else
            "PENDING"
        end
    end

    def linkRSVP(invite)
        yes_link = link_to 'YES', rsvp_path(getTrip(invite).url, 'yes'), method: :patch
        maybe_link =  link_to 'MAYBE', rsvp_path(getTrip(invite).url, 'maybe'), method: :patch
        no_link = link_to 'NO', leave_trip_path(getTrip(invite).url), method: :delete, data: {confirm: 'You sure?'}

        case getRSVP(invite)
        when "GOING"
           [maybe_link, no_link]
        when "MAYBE"
            [yes_link, no_link]
        else
            [yes_link, maybe_link, no_link]
        end
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

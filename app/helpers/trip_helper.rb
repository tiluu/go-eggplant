module TripHelper
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
            creator( invite.trip ) == current_user 
        else
            creator(trip) == current_user 
        end
    end

    def currency
        begin 
          url = "http://api.fixer.io/latest"
          rates = HTTParty.get(url)
          JSON.parse(rates.body)
        rescue JSON::ParserError => e
          "Something went wrong--please refresh the trip page."
        end
    end

    def getCurrency
        list = currency['rates'].keys
        list << currency['base']
        list.sort!
    end

    def timezones
        timezone_list = []
        ActiveSupport::TimeZone.all.each do |zone|
            timezone_list << zone.name
        end
        timezone_list
    end

    def getRSVP(invite)
        if invite.rsvped?
            invite.going? && !invite.maybe? ? "GOING" : "MAYBE"
        else
            "PENDING"
        end
    end

    def linkRSVP(invite)
        yes_link = link_to 'YES', rsvp_path(invite.trip.url, 'yes'), method: :patch
        maybe_link =  link_to 'MAYBE', rsvp_path(invite.trip.url, 'maybe'), method: :patch
        no_link = link_to 'NO', leave_trip_path(invite.trip.url), method: :delete, data: {confirm: 'You sure?'}

        case getRSVP(invite)
        when "GOING"
           [maybe_link, no_link]
        when "MAYBE"
            [yes_link, no_link]
        else
            [yes_link, maybe_link, no_link]
        end
    end

    def days_left(startdate, enddate)
        ( (startdate - enddate)/86400 ).ceil
    end

    def count(days)
        pluralize(days.abs, 'day')
    end

    def trip_countdown
        if days_left(@trip.start_date, Time.now) > 1
            num_days = days_left(@trip.start_date, Time.now)
            countdown = "Starts in #{count(num_days)}"
        elsif days_left(@trip.start_date, Time.now) === 1
        	countdown = "Starts tomorrow!"
        elsif @trip.start_date <= Time.now && @trip.end_date >= Time.now
        	num_days = days_left(Time.now, @trip.start_date)
        	countdown = "Started #{count(num_days)} ago"
        elsif @trip.end_date < Time.now
        	num_days = days_left(Time.now, @trip.end_date)
        	countdown = "Ended #{count(num_days)} ago"
        end
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

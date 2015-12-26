module TripHelper
    def trip_countdown
        days = (@trip.start_date - Time.now)/86400
        pluralize(days.ceil, 'day')
    end

    def headcount(trip)
        count = trip.friends.count + 1
        pluralize(count, 'person')
    end

end

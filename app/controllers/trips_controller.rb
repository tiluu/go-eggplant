class TripsController < ApplicationController
    def index
        @trips = Trip.all
        @result = Yelp.client.search('Vancouver BC', {term:'coffee', limit: 10})
    end

    def new
        @trip = Trip.new
    end

    def create
        @trip = Trip.new(trip_params)
        if @trip.save
            redirect_to action: 'index'
        else
            render 'new'
        end
    end

    private
        def trip_params
            params.require(:trip).permit(:name, :start_date,
                                         :end_date, :location,
                                         :password)
        end

end

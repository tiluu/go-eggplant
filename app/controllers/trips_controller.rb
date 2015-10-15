class TripsController < ApplicationController
    def index
        #@trips = Trip.all
        @result = Yelp.client.search('Vancouver BC', {term:'coffee', limit: 10})
    end

end

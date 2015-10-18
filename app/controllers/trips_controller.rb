class TripsController < ApplicationController
    def index
        @trips = Trip.all
    end

    def show
        @trip = Trip.find(params[:id])
        search_params = @trip.city + @trip.state_or_province + @trip.country
        @result = Yelp.client.search(search_params, {term: 'restaurants', limit: 10})
    end

    def new
        @trip = Trip.new
        @trip.users.build
    end

    def create
        @trip = Trip.new(trip_params)
        if @trip.save
            redirect_to @trip
        else
            @errors = @trip.errors
            render :new
        end
    end

    def edit
        @trip = Trip.find(params[:id])
    end

    def update
        @trip = Trip.find(params[:id])
        if @trip.update_attributes(trip_params)
            redirect_to @trip
        else
            @errors = @trip.errors
            render 'edit'
        end
    end

    def yelp_results
        @trip = Trip.find(params[:id])
        search_params = @trip.city + @trip.state_or_province + @trip.country
        @result = Yelp.client.search(search_params, {term: 'restaurants', limit: 20})
    end

    def destroy
        Trip.find(params[:id]).destroy
        redirect_to action: 'index'
    end

    private
        def trip_params
            params.require(:trip).permit(:name, :start_date,
                                         :end_date, :city, 
                                         :state_or_province,
                                         :country, :password,
                                         users_attributes: [:name, :email])
        end

end

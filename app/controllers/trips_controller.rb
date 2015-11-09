class TripsController < ApplicationController
    include ApplicationHelper

    def index
        @user = User.find(params[:user_id])
        @trips = @user.trips
    end

    def show
        @user = User.find(params[:user_id])
        @trip = @user.trips.find_by_url(params[:url])
        
        
        location = @trip.city + @trip.state_or_province + @trip.country

        if !params[:neighborhood] 
           search_params = location 
        else 
           search_params = params[:neighborhood] + location 
        end 

        params[:sort].present? ? sort = params[:sort] : sort = 0

        yelp_api(search_params, 'restaurants', sort)
    end

    def new
        @user = User.find(params[:user_id])
        @trip = @user.trips.build
    end

    def create
        @user = User.find(params[:user_id])
        @trip = @user.trips.build(trip_params)
        # or have people come up with their own URLs
        @trip.url = SecureRandom.urlsafe_base64
        if @trip.save
            redirect_to trip_url_path(url: @trip.url)
        else
            @errors = @trip.errors
            render :new
        end
    end

    def edit
        @user = User.find(params[:user_id]
        @trip = @user.trips.find_by_url(params[:url])
    end

    def update
        @user = User.find(params[:user_id])
        @trip = @user.trips.find(params[:id])
        if @trip.update_attributes(trip_params)
            redirect_to trip_url_path(url: @trip.url)
        else
            @errors = @trip.errors
            render :edit
        end
    end

    def yelp_results
        @user = User.find(params[:user_id])
        @trip = @user.trips.find_by_url(params[:url])
        search_params = @trip.city + @trip.state_or_province + @trip.country
        yelp_api(search_params, 'restaurants', 20)
    end

    def destroy
        @user = User.find(params[:user_id]
        @user.trips.find_by_id(params[:id]).destroy
        redirect_to action: 'index'
    end

#    def show_by_url
#        @trip = Trip.find_by_url(params[:url])
#        render :show
#    end

    private
        def trip_params
            params.require(:trip).permit(:name, :url, :start_date,
                                         :end_date, :city, 
                                         :state_or_province,
                                         :country)
        end

end

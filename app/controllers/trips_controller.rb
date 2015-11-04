class TripsController < ApplicationController
    include ApplicationHelper

    def index
        @trips = Trip.all
    end

    def show
        @trip = Trip.find_by_url(params[:url])
        @users = @trip.users
        
        location = @trip.city + @trip.state_or_province + @trip.country

        if !params[:neighborhood] 
           @search_params = location 
        else 
           @search_params = params[:neighborhood] + location 
        end 

        yelp_api(@search_params, 'restaurants')
    end

    def new
        @trip = Trip.new
        @trip.users.build
    end

    def create
        @trip = Trip.new(trip_params)
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
        @trip = Trip.find_by_url(params[:url])
    end

    def update
        @trip = Trip.find(params[:id])
        if @trip.update_attributes(trip_params)
            redirect_to trip_url_path(url: @trip.url)
        else
            @errors = @trip.errors
            render :edit
        end
    end

    def yelp_results
        @trip = Trip.find_by_url(params[:url])
        search_params = @trip.city + @trip.state_or_province + @trip.country
        yelp_api(search_params, 'restaurants', 20)
    end

    def destroy
        Trip.find(params[:id]).destroy
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
                                         :country, :password,
                                         :password_confirmation,
                                         users_attributes: [:id, :name, :email])
        end

end

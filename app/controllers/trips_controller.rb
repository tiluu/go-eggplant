class TripsController < ApplicationController
    def index
        @trips = Trip.all
    end

    def show
        @trip = Trip.find_by_url(params[:url])
        @users = @trip.users
        search_params = @trip.city + @trip.state_or_province + @trip.country
        @result = Yelp.client.search(search_params, {term: 'restaurants', limit: 10})
    end

    def new
        @trip = Trip.new
        @trip.users.build
    end

    def create
        @trip = Trip.new(trip_params)
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
        @trip = Trip.find(params[:id])
        search_params = @trip.city + @trip.state_or_province + @trip.country
        @result = Yelp.client.search(search_params, {term: 'restaurants', limit: 20})
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

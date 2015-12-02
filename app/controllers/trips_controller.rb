class TripsController < ApplicationController
    before_action :require_login
   
    def show
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        @ideas = @trip.ideas
        
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
        @user = current_user
        @trip = @user.trips.build
    end

    def create
        @user = current_user
        @trip = @user.trips.build(trip_params)
        # or have people come up with their own URLs
        @trip.url = SecureRandom.urlsafe_base64
        if @trip.save
            redirect_to trip_path(@trip.url)
        else
            @errors = @trip.errors
            render :new
        end
    end

    def edit
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
    end

    def update
        @user = current_user
        @trip = @user.trips.find(params[:id])
        if @trip.update_attributes(trip_params)
            redirect_to trip_path(@trip.url)
        else
            @errors = @trip.errors
            render :edit
        end
    end

    def yelp_results
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        search_params = @trip.city + @trip.state_or_province + @trip.country
        yelp_api(search_params, 'restaurants', 20)
    end

    def destroy
        @user = current_user
        @user.trips.find_by_id(params[:id]).destroy
        redirect_to dashboard_path
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
                                         :country,
                                        ideas_attributes: [:title, :start_date,                                                                         :end_date, :start_time,
                                                        :end_time, :location,                                                                           :notes, :category] )
        end

end

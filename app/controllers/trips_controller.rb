class TripsController < ApplicationController
    before_action :require_login

    def find_food
        @trip = current_trips.find_by_url(params[:url])

        location = @trip.city + @trip.state_or_province + @trip.country
        if !params[:neighborhood] 
           search_params = location 
        else 
           search_params = params[:neighborhood] + location 
        end 

        params[:sort].present? ? sort = params[:sort] : sort = 0

        yelp_api(search_params, 'restaurants', sort)
    end
  
    def show
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        @action = 'create' 

        @food = @trip.ideas.where(idea_category_id: 1)
        @event = @trip.ideas.where(idea_category_id: 3) 
        @activity = @trip.ideas.where(idea_category_id: 4)
    end

    def new
        @user = current_user
        @trip = @user.trips.build
        @action = 'new' # for getPath helper
    end

    def create
        @user = current_user
        @trip = @user.trips.build(trip_params)
        @action = 'create'
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
        @action = 'edit'
    end

    def update
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        @action = 'update'
        if @trip.update_attributes(trip_params)
            redirect_to trip_path(@trip.url)
        else
            @errors = @trip.errors
            render :edit
        end
    end

#    def yelp_results
#        @user = current_user
#        @trip = @user.trips.find_by_url(params[:url])
#        search_params = @trip.city + @trip.state_or_province + @trip.country
#        yelp_api(search_params, 'restaurants', 20)
#    end

    def destroy
        @user = current_user
        @user.trips.find_by_id(params[:id]).destroy
        redirect_to dashboard_path
    end

    private
        def trip_params
            params.require(:trip).permit(:name, :url, :start_date,
                                         :end_date, :city, 
                                         :state_or_province,
                                         :country)
        end 
end

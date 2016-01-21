class TripsController < ApplicationController
    before_action :require_login

    def find_food
        @trip = current_trips.find_by_url(params[:url])
        location = @trip.city + " " + @trip.country
        if !params[:neighborhood] 
           search_params = location 
        else 
           search_params = params[:neighborhood] + location 
        end 

        params[:sort].present? ? sort = params[:sort] : sort = 0

        yelp_api(search_params, 'restaurants', sort)
    end
  
    def show
        @trip = current_trips.find_by_url(params[:url])
        @action = 'create' 
        @pending = @trip.invites.where(rsvped?: nil)

        getIdeas(@trip)
    end

    def new
        @trip = current_trips.build
        @invite = @trip.invites.build
        @action = 'new' # for getPath helper
    end

    def create
        @trip = current_trips.build(trip_params)
        @trip.creator = current_user.id
        @action = 'create'
        if @trip.save
            @invite = @trip.invites.create(user_id: current_user.id,
                                           email: current_user.email,
                                           user_tag: current_user.tag,
                                           rsvped?: true, going?: true)
            if @invite.present?
                redirect_to trip_path(@trip.url)
            else
                flash[:danger].now = "error"
                render :new
            end
        else
            @errors = @trip.errors
            render :new
        end
    end

    def edit
        @trip = current_trips.find_by_url(params[:url])
        @action = 'edit'
    end

    def update
        @trip = current_trips.find_by_url(params[:url])
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
        currrent_trips.find_by_url(params[:url]).destroy
        redirect_to dashboard_path
    end

    private
        def trip_params
            params.require(:trip).permit(:name, :url, :start_date,
                                         :end_date, :city, 
                                         :country, :creator)
        end 
end

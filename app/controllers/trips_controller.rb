class TripsController < ApplicationController
    before_action :require_login
    load_and_authorize_resource
   
    def show
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        @group = TravelGroup.find_by(trip_id: @trip.id)
        @food = @trip.ideas.where(category: 'food')
        @event = @trip.ideas.where(category: 'event')
        @activity = @trip.ideas.where(category: 'activity')

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
        @group = TravelGroup.new
    end

    def create
        @user = current_user
        @trip = @user.trips.build(trip_params)
        # or have people come up with their own URLs
        @trip.url = SecureRandom.urlsafe_base64
        if @trip.save
            @group = TravelGroup.create(user_id: @user.id, trip_id: @trip.id)
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
        @trip = @user.trips.find_by_url(params[:url])
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

    def invite
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        @group = @trip.travel_group.find(params[:id])
    end

    def send_invite
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])
        @group = @trip.travel_group.find(params[:id])
        @friend = User.find_by_email(params[:email])
        if @friend.present? && @group.update_attributes(group_params)
            @friend.role = "TRAVEL_BUDDY"
            @friend.save
            flash[:success] = "Friend added"
            redirect_to trip_path(@trip.url)
        else
            flash.now[:danger] = "Friend not found"
            render :invite
        end
    end

    private
        def trip_params
            params.require(:trip).permit(:name, :url, :start_date,
                                         :end_date, :city, 
                                         :state_or_province,
                                         :country,
                                         )
        end     
end

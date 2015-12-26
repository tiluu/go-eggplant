class TripsController < ApplicationController
    #include GroupTrips
    before_action :require_login
    before_action :check_friend, only: [:show_group, :leave_trip]

    def invite
        @trip = current_trips.find_by_url(params[:url])
        @invite = @trip.relationships.build
    end

    def send_invite
        @trip = current_trips.find_by_url(params[:url])
        @invite = @trip.relationships.build(friend_params)
        @trip.get_friend_id(@invite)

        if @invite.save
            flash[:success] = "Friend added!"
            redirect_to trip_path(@trip.url)
        else
            @errors = @invite.errors
            render :invite
        end
    end
    
    def uninvite
        @trip = current_trips.find_by_url(params[:url])
        email = params[:email] + params[:format]
        @trip.relationships.find_by(email: email).destroy
        flash[:success] = "Friend uninvited"
        redirect_to dashboard_path        
    end

    def leave_trip
        @inviter = current_user.group_trips.find_by_url(params[:url]).user
        @trip = @inviter.trips.find_by_url(params[:url])
        @trip.relationships.find_by(friend_id: current_user).destroy
        flash[:success] = "Successfully left the trip"
        redirect_to dashboard_path
    end   

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
    
    def show_group
        @action = 'create'
        @inviter = current_user.group_trips.find_by_url(params[:url]).user
        @trip = @inviter.trips.find_by_url(params[:url])
        @food = @trip.ideas.where(idea_category_id: 1)
        @event = @trip.ideas.where(idea_category_id: 3) 
        @activity = @trip.ideas.where(idea_category_id: 4)
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

        def friend_params
            params.require(:relationship).permit(:email, :group_trip_id, :friend_id)
        end

        def check_friend
            trip = Trip.find_by_url(params[:url])
            find_friend = Relationship.find_by(group_trip_id: trip.id, friend_id: current_user.id)
            if !find_friend 
                flash[:danger] = "You do not have access to the page."
                redirect_to dashboard_path
            end
            
        end
end

class TripsController < ApplicationController
    before_action :require_login

    def invite
        @trip = current_user.trips.find_by_url(params[:url])
        @invite = @trip.relationships.build
    end

    def send_invite
        @trip = current_user.trips.find_by_url(params[:url])
        @invite = @trip.relationships.build(friend_params)
        @invited = User.find_by(email: @invite.email)
        @invite.friend_id = @invited.id
        
        if @invite.save
            flash[:success] = "Friend added!"
            redirect_to trip_path(@trip.url)
        else
            @errors = @invite.errors
            render :invite
        end
    end


    def uninvite
        @trip = current_user.trips.find_by_url(params[:url])
        @trip.relationships.find_by(friend_id: params[:friend_id]).destroy
    end   

    def find_food
        @user = current_user
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
    
    def show_group
        @inviter = current_user.group_trips.find_by_url(params[:url]).user
        @trip = @inviter.trips.find_by_url(params[:url])
        @friends = @trip.friends 
        @food = @trip.ideas.where(idea_category_id: 1)
        @event = @trip.ideas.where(idea_category_id: 3) 
        @activity = @trip.ideas.where(idea_category_id: 4)
    end
  
    def show
        @user = current_user
        @trip = @user.trips.find_by_url(params[:url])

        @food = @trip.ideas.where(idea_category_id: 1)
        @event = @trip.ideas.where(idea_category_id: 3) 
        @activity = @trip.ideas.where(idea_category_id: 4)
    end

    def new
        @user = current_user
        @trip = @user.trips.build
    end

    def create
        @user = current_user
        @trip = @user.trips.build(trip_params)
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
end

class GroupTripsController < ApplicationController
	before_action :require_login
    before_action :check_friend, only: [:show_group, :leave_trip]

	def invite
        @trip = current_trips.find_by_url(params[:url])
        @invite = @trip.relationships.build
        @action = 'invite'
    end

    def send_invite
        @action = 'send_invite'
        @trip = current_trips.find_by_url(params[:url])
        @invite = @trip.relationships.build(friend_params)
        if User.registered?(@invite) && @invite.save
            @trip.get_friend_id(@invite)
            @invite.save
            flash[:success] = "Friend added!"
            redirect_to trip.url(@trip.url)
        elsif @invite.valid? && @trip.send_invite(current_user, @invite)
            flash[:success] = "Invite sent!"
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

    def show_group
        @action = 'create'
        @inviter = current_user.group_trips.find_by_url(params[:url]).user
        @trip = @inviter.trips.find_by_url(params[:url])
        @food = @trip.ideas.where(idea_category_id: 1)
        @event = @trip.ideas.where(idea_category_id: 3) 
        @activity = @trip.ideas.where(idea_category_id: 4)
    end

    private
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

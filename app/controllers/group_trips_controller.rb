class GroupTripsController < ApplicationController
	before_action :require_login
    before_action :check_friend, only: [:show_group, :leave_trip]

	def invite
        @trip = current_trips.find_by_url(params[:url])
        @invite = @trip.invites.build
        @action = 'invite'
    end

    def send_invite
        @action = 'send_invite'
        @trip = current_trips.find_by_url(params[:url])
        @invite = @trip.invites.build(invite_params)
        @invite.sender = current_user.id
        @invite.rsvp = 'PENDING'
        if @invite.save
            Relationship.get_user_id(@invite)
            if !User.registered?(@invite) 
                Relationship.send_invite(current_user, @invite)
            end
            flash[:success] = "Invite sent!"
            redirect_to trip_path(@trip.url)
        else
            @errors = @invite.errors
            render :invite
        end
    end
    
    def uninvite
        @trip = current_trips.find_by_url(params[:url])
        Relationship.where(user_tag: params[:tag], trip_id: @trip.id).first.destroy
        flash[:success] = "Friend uninvited"
        redirect_to trip_path(@trip.url)       
    end

    def leave_trip
        @trip = current_trips.find_by_url(params[:url])
        Relationship.where(user_tag: current_user.tag, trip_id: @trip.id).first.destroy
        flash[:success] = "Successfully left the trip"
        redirect_to dashboard_path
    end   

    def rsvp_yes
       @invited_trip = current_user.invited_trips.find_by_url(params[:url]) 
       @invite = @invited_trip.trip_invites.find_by(friend_id: current_user.id)
       @invite.update_attribute(:rsvped, 'YES')
       @friend = @invited_trip.relationships.create(friend_id: current_user.id,
                                            email: current_user.email)
       redirect_to group_trip_path(@trip.url)
    end

    def rsvp_no
    end
    
    def show_group
        @action = 'create'
        @inviter = current_user.group_trips.find_by_url(params[:url]).user
        @trip = @inviter.trips.find_by_url(params[:url])
        @food = @trip.ideas.where(idea_category_id: 1)
        @event = @trip.ideas.where(idea_category_id: 3) 
        @activity = @trip.ideas.where(idea_category_id: 4)
    end

    def invites
        @trip = current_trips.find_by_url(params[:url])
        @pending = @trip.invites
        @friends = @trip.friends
    end

    private
    	def invite_params
            params.require(:invite).permit(:email, :user_tag, 
                                           :rsvp, :trip_id, 
                                           :sender, :user_id)
        end

        def check_friend
            trip = Trip.find_by_url(params[:url])
            find_friend = Relationship.find_by(trip_id: trip.id, user_id: current_user.id)
            if !find_friend 
                flash[:danger] = "You do not have access to the page."
                redirect_to dashboard_path
            end            
        end
end

class GroupTripsController < ApplicationController
	before_action :require_login
    before_action :check_friend, only: [:show_group]

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

    def rsvp
       @trip = current_trips.find_by_url(params[:url]) 
       @invite = @trip.invites.where(trip_id: @trip.id, user_id: current_user.id).first
       resp = params[:response]
       case resp
       when 'yes'
        @invite.update(going?: true, maybe?: false)
       when 'maybe'
        @invite.update_attributes(maybe?: true, going?: false)
       end
       @invite.update_attribute(:rsvped?, true)
       redirect_to dashboard_path
       # if resp === 'no'
       #      flash[:info] = "RSVP updated."
       #      @invite.update(maybe?: false, going?: false)
       #      redirect_to dashboard_path
       #  else
       #      redirect_to trip_path(@trip.url)
       #  end
    end  

    def invites
        @trips = current_trips
    end

    private
    	def invite_params
            params.require(:invite).permit(:email, :user_tag, 
                                           :rsvped?, :trip_id, 
                                           :sender, :user_id,
                                           :going?, :maybe?)
        end

        def check_friend
            trip = Trip.find_by_url(params[:url])
            find_friend = Relationship.find_by(trip_id: trip.id, user_id: current_user.id)
            if !find_friend || current_user.id != trip.creator
                flash[:danger] = "You do not have access to the page."
                redirect_to dashboard_path
            end            
        end
end

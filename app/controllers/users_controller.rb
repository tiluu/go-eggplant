class UsersController < ApplicationController
    def new
        @trip = Trip.find(params[:trip_id])
        @user = @trip.users.build
    end

    def create
        @trip = Trip.find(params[:trip_id])
        @user = @trip.users.build(user_params)
        if @user.save
            redirect_to @user
        else
            @errors = @user.errors
            render :new
        end
    end
    
    def destroy
        #@trip = Trip.find(params[:trip_id])
        #@trip.users.find_by_id(params[:id]).destroy
        @user = User.find(params[:id]).destroy
        redirect_to trip_path(@user.trip_id)
    end

    private
        def user_params
            params.require(:user).permit(:name, :email,
                                         :phone)
        end
end

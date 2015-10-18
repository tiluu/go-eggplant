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

    private
        def user_params
            params.require(:user).permit(:name, :email,
                                         :phone)
        end
end

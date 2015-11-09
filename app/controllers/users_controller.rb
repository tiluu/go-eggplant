class UsersController < ApplicationController
    def login
    end

    def authenticate
        @user = User.authenticate(params[:email], params[:password])
        if @user
            redirect_to user_path(@user.id)
        else
            render :login
        end
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to user_path(@user.id)
        else
            @errors = @user.errors
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
        @trips = @user.trips
    end
    
    def destroy
        User.find(params[:id]).destroy
        #@user = User.find(params[:id]).destroy
        redirect_to root_path
    end

    private
        def user_params
            params.require(:user).permit(:name, :email,
                                         :phone, :password, 
                                         :password_confirmation)
        end
end

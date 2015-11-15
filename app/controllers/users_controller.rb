class UsersController < ApplicationController
    before_action :require_login, only: [:edit, :update, :destroy, :show]

    def login
    end

    def authenticate
    @current_user = User.authenticate(params[:email], params[:password])
    if @current_user
            login_user(@current_user)
        else
            flash[:danger] = "Wrong email/password combination"
            render :login
        end
    end

    def logout
        session.delete(:user_id)
        flash[:success] = "Logged out successfully"
        redirect_to root_path
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            login_user(@user)
            #redirect_to user_path(@user.id)
        else
            @errors = @user.errors
            render :new
        end
    end

    def show
        @current_user = current_user
        @trips = @current_user.trips
    end

    def edit
        @current_user = current user
    end

    def update
        @current_user = current_user
    end
    
    def destroy
        current_user.destroy
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

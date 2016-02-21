class UsersController < ApplicationController
    before_action :require_login, only: [:edit, :update, :destroy, :show]
    before_action :require_logout, only: [:new, :create]

    def login
    end

    def authenticate
    @current_user = User.authenticate(params[:email], params[:password])
    if @current_user
            login_user(@current_user)
        else
            flash[:danger] = "Wrong email/password combination"
            redirect_to root_path
        end
    end

    def logout
        session.delete(:user_id)
        flash[:success] = "Logged out successfully"
        redirect_to root_path
    end
 
    def new
        @user = User.new
        @action = 'new' # getPath helper
    end

    def create
        @user = User.new(user_params)
        @action = 'create'
        if @user.save
            login_user(@user)
        else
            @errors = @user.errors
            render :new
        end
    end

    def show
        @created_trips = current_user.trips.where(ended?: nil)
        @invites = current_user.invites
        @pending = @invites.where(rsvped?: nil)
        @invited_trips = @invites.where(rsvped?: true)
        @action = 'create'
    end

    def past_trips
        @invites = current_user.invites
        @ended_trips = current_user.trips.where(ended?: true)
    end


    def edit
        @action = 'edit'
    end

    def update
        @action = 'update'
        if current_user.update_attributes(user_params)
            flash[:success] = "Profile updated"
            redirect_to dashboard_path
        else
            @errors = current_user.errors
            render :edit
        end
    end
    
    def destroy
        current_user.destroy
        redirect_to root_path
    end

    private
        def user_params
            params.require(:user).permit(:name, :email,
                                         :password, :tag,
                                         :password_confirmation
                                         )
        end

end

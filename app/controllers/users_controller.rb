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
            flash.now[:danger] = "Wrong email/password combination"
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
        @current_user = current_user
        @trips = @current_user.trips
        @invites = @current_user.invites
    end

    def edit
        @current_user = current_user
        @action = 'edit'
    end

    def update
        @current_user = current_user
        @action = 'update'
        if @current_user.update_attributes(user_params)
            flash[:success] = "Profile updated"
            redirect_to dashboard_path
        else
            @errors = @current_user.errors
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

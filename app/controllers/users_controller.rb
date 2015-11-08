class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new
        if @user.save
            redirect_to user_path(@user.id)
        else
            @errors = @user.errors
            render :new
        end
    end
    
    def destroy
        User.find(params[:id]).destroy
        #@user = User.find(params[:id]).destroy
        redirect_to root_path
    end

    private
        def user_params
            params.require(:user).permit(:name, :email,
                                         :phone)
        end
end

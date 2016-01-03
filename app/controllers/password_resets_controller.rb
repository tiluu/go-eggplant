class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:email])
  	user.send_password_reset if user
  	flash[:info] = "Email sent with password reset instructions"
  	redirect_to root_path
  end

  def edit
  	@user = User.find_by_password_reset_token!(params[:token])
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:token])
  	curr_pw = @user.password
  	if @user.password_reset_sent_at < 2.hours.ago
  		flash[:danger] = "Password reset has expired"
  		redirect_to password_reset_path
  	elsif @user.update_attributes(pw_params) && curr_pw != @user.password
  		flash[:success] = "Your password has been reset"
  		redirect_to login_path
  	else
  		flash.now[:danger] = "Your entries were invalid, please try again."
  		render :edit
  	end
  end

  private
  	def pw_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end

end

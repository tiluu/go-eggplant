class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
      @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
      if current_user.nil? 
          flash[:danger] = "Please log in before proceeding"
          redirect_to login_path
      end
  end

  def login_user(user)
      session[:user_id] = user.id
      redirect_to dashboard_path
  end

  helper_method :current_user, :require_login, :login_user
end

class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
      @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_trips
      @current_trip = current_user.trips
  end

  def require_login
      if current_user.nil? 
          flash[:danger] = "Please log in before proceeding"
          redirect_to login_path
      end
  end
  
  def require_logout
      if current_user.present? 
          flash[:danger] = "Please log out first"
          redirect_to dashboard_path
      end
  end

  def login_user(user)
      session[:user_id] = user.id
      redirect_to dashboard_path
  end

  def yelp_api(location, terms, sort=0, category='', offset=0, limit=15, radius=5000) 
     begin
         @result = Yelp.client.search(location, 
                                      {term: terms,
                                       limit: limit,
                                       sort: sort,
                                       offset: offset,
                                       radius_filter: radius,
                                       category_filter: category })
    rescue Yelp::Error::UnavailableForLocation => e
        l = location.split(' ')
        loc = l.join(" ")
        @yelp_error = "No results available for #{loc}"
    end
  end
        
  helper_method :current_user, :require_login, :login_user, :yelp_api
end

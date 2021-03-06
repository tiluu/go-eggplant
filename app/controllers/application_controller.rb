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

  def getIdeas(trip)
    @food = trip.ideas.where(idea_category_id: 1)
    @event = trip.ideas.where(idea_category_id: 3) 
    @activity = trip.ideas.where(idea_category_id: 4)
    {food: @food, event: @event, activity: @activity}
  end

  def location_error(location)
    l = location.split(' ')
    loc = l.join(" ")
    @yelp_error = "No results available for #{loc}"
  end

  # set default values if certain API search params not present
  def api_params(param, default_value, param_modifier)
    !param ? default_value : param + param_modifier
  end

  def foursquare_api(location, category)
    id = ENV['4SQUARE_CLIENT_ID']
    secret = ENV['4SQUARE_CLIENT_SECRET']
    version = Time.now.strftime("%Y%m%d")

    url= "https://api.foursquare.com/v2/venues/search?client_id="+id+"&client_secret="+secret+"&v="+version+"&near="+location+"&categoryId="+category+"&limit=50"
    request = HTTParty.get(url)
    attractions = JSON.parse(request.body)
    attractions['response']['venues']  
  end

  def yelp_api(location, terms, sort=0, category='', offset=0, radius=5000) 
    begin
    @result = Yelp.client.search(location, 
                                 {term: terms,
                                  sort: sort,
                                  offset: offset,
                                  radius_filter: radius,
                                  category_filter: category })
    rescue Yelp::Error::UnavailableForLocation => e
      location_error(location) 
    rescue JSON::ParserError => e
      location_error(location)
    rescue Yelp::Error::InvalidParameter => e
      location_error(location)
    end
  end
        
  helper_method :current_user, :yelp_api, :api_params
end

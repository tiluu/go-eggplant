class IdeasController < ApplicationController
  before_action :require_login
  respond_to :html, :json

  def find_food
   @trip = current_trips.find_by(url: params[:url])
   @idea = @trip.ideas.find(params[:id])
   @going = @trip.invites.where(going?: true) # for header

   location = @trip.city + " " + @trip.country
   search_params ||= api_params(params[:neighborhood],
                              location, location)
   sort ||= api_params(params[:sort], 0, 0)

   yelp_api(search_params, 'restaurants', sort)
  end

  def find_events
    @trip = current_trips.find_by(url: params[:url])
    @idea = @trip.ideas.find(params[:id])
    @going = @trip.invites.where(going?: true)

    location = @trip.city + " " + @trip.country

    # TODO: sub hard-coded Foursquare category ID [currently correspond to Arts & Entertainment] for user choice! 
    category ||= api_params(params[:event_category],
                            '4d4b7104d754a06370d81259','')
    @attractions = foursquare_api(location, category)
  end

  def add_idea
    @trip = current_trips.find_by_url(params[:url])
    @idea = @trip.ideas.build(title: params[:title], location: params[:address],
                              idea_category_id: params[:category].to_i, user_id: current_user.id)
    if @idea.save
      redirect_to trip_path(@trip.url)
    else
      @errors = @idea.errors
      render :new
    end
  end

  def new
    @trip = current_trips.find_by_url(params[:url])
    @idea = @trip.ideas.build
  end

  def create
    @trip = current_trips.find_by_url(params[:url])
    @idea = @trip.ideas.build(idea_params)
    @action = 'create'
    if @idea.save
        redirect_to trip_path(@trip.url)
    else
        @errors = @idea.errors
        render :new
    end
  end

  def index
    @trip = current_trips.find_by_url(params[:url])
    @ideas = getIdeas(@trip)
    render json: @ideas
  end

  def show
    @trip = current_trips.find_by(url: params[:url])
    @idea = @trip.ideas.find(params[:id])
  end

#    def edit
#        @trip = current_trips.find_by_url(params[:url])
#        @idea = @trip.ideas.find(params[:id])
#        @action = 'edit'
#    end

  def update
    @action = 'update'
    @trip = current_trips.find_by(url: params[:url])
    @idea = @trip.ideas.find(params[:id])

    if @idea.update_attributes(idea_params)
      respond_with @idea
    else
      @errors = @trip.errors
      redirect_to trip_path(@trip.url)
    end
  end

  def destroy
    @trip = current_trips.find_by(url: params[:url])
    @idea = @trip.ideas.find(params[:id])
    @idea.destroy
    redirect_to trip_path(@trip.url)
  end

  private
    def idea_params
      params.require(:idea).permit(:title, :start_date,
                                   :end_date, :start_time,
                                   :end_time, :location,
                                   :notes, :idea_category_id,
                                   :user_id, :trip_id)
    end
end

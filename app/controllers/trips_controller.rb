class TripsController < ApplicationController
  before_action :require_login

  def timezones
    @timezones = {}
    ActiveSupport::TimeZone.all.each do |zone|
      @timezones[zone.name] = zone.utc_offset
    end
    render json: @timezones
  end

  def show
    @trip = current_trips.find_by_url(params[:url])
    @action = 'create'
    @pending = @trip.invites.where(rsvped?: nil)
    @going = @trip.invites.where(going?: true)

    @group = getIdeas(@trip)
  end

  def new
    @trip = current_trips.build
    @invite = @trip.invites.build
    @action = 'new' # for getPath helper
  end

  def create
    @trip = current_trips.build(trip_params)
    @trip.creator = current_user.id
    @action = 'create'
    if @trip.save
      @invite = @trip.invites.create(user_id: current_user.id,
                                     email: current_user.email,
                                     user_tag: current_user.tag,
                                     rsvped?: true, going?: true)
      if @invite.present?
        redirect_to trip_path(@trip.url)
      else
        flash[:danger].now = "error"
        render :new
      end
    else
      @errors = @trip.errors
      render :new
    end
  end

  def edit
    @action = 'edit'
    @trip = current_trips.find_by(url: params[:url])
  end

  def update
    @action = 'update'
    @trip = current_trips.find_by(url: params[:url])
    if @trip.update_attributes(trip_params)
      redirect_to trip_path(@trip.url)
    else
      @errors = @trip.errors
      render :edit
    end
  end

  def destroy
    @trip = current_trips.find_by(url: params[:url])
    @trip.destroy
    redirect_to dashboard_path
  end

  private
    def trip_params
      params.require(:trip).permit(:name, :url, :start_date,
                                   :end_date, :city,
                                   :country, :creator, :ended?)
    end
end

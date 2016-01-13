class IdeasController < ApplicationController
    before_action :require_login
    respond_to :html, :json 

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
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.find(params[:id])
    end

#    def edit
#        @trip = current_trips.find_by_url(params[:url])
#        @idea = @trip.ideas.find(params[:id])
#        @action = 'edit'
#    end

    def update
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.find(params[:id])
        @action = 'update'

        if @idea.update_attributes(idea_params)
            respond_with @idea
        else
            @errors = @trip.errors
            redirect_to trip_path(@trip.url)
        end
    end

    def destroy
        @trip = current_trips.find(params[:trip_id])
        @trip.ideas.find(params[:id]).destroy
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

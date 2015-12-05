class IdeasController < ApplicationController
    before_action :require_login

    def index
        @trip = current_trips.find_by_url(params[:url])
        @ideas = @trip.ideas
    end

    def new
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.build
    end

    def create
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.build(idea_params)
        
        if @idea.save
            redirect_to trip_path(@trip.url)
        else
            @errors = @idea.errors
            render :new
        end
    end

    def show
        @trip = current_user.trips.find_by_url(params[:url])
        @idea = @trip.ideas.find(params[:id])
    end

    def edit
    end

    def update
    end

    def destroy
        @trip = current_user.trips.find_by_url(:url)
        @trip.ideas.find(params[:id]).destroy
        redirect_to trip_path(@trip.url)
    end

    private
        def idea_params
            params.require(:idea).permit(:title, :start_date, 
                                         :end_date, :start_time,
                                         :end_time, :location,
                                         :notes)
        end
       
end

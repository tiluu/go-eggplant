class IdeasController < ApplicationController
    before_action :require_login

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
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.find(params[:id])
    end

    def edit
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.find(params[:id])
    end

    def update
        @trip = current_trips.find_by_url(params[:url])
        @idea = @trip.ideas.find(params[:id])

        if @idea.update_attributes(idea_params)
            redirect_to idea_path(@trip.url, params[:id])
        else
            @errors = @trip.errors
            render :edit
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

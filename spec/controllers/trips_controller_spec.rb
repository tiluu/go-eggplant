require 'rails_helper'

RSpec.describe TripsController, type: :controller do  
#    describe 'External API request' do 
#        before do
#            stub_request(:get, "http://api.yelp.com/v2/search?limit=10&location=VancouverBCCanada&term=restaurants").to_return(:body => response, :status => 200, :headers => {})
#        end
 
#        it 'queries the Yelp API' do 
#            client = Yelp::Client.new(:host => 'www.yelp.com')
#            search_params = "Vancouver BC Canada"
#            response = client.search(search_params, {term: 'food', limit: 10})
            #uri = URI("https://api.yelp.com/v2/search?term=food&location=Vancouver+BC")
            #response = Net::HTTP.get(uri)
#            expect(response).to eq(response)
#        end
#    end

    describe 'GET index' do
        before(:each) do 
            get :index
        end

        it 'renders the index template' do 
            expect(response).to render_template(:index)
        end
        
        it 'populates @trips with all trips' do
            expect(assigns(:trips)).to eq(Trip.all)
        end
    end

    describe 'GET new' do
        before(:each) do 
            get :new
        end

        it 'renders the new view' do
            expect(response).to render_template(:new)
        end

        it 'assigns new trips to an instance variable' do 
            expect(assigns(:trip)).to be_a_new(Trip)
        end
    end

    describe 'POST create' do
        before(:each) do 
            @dummy_trip = {
                name: "Portland 2015",
                start_date: "Oct 19 2015",
                end_date: "Oct 20 2015", 
                city: "Portland",
                state_or_province: "OR", 
                country: "USA"}
        end

        after(:each) do
            trip = Trip.find_by_name("Portland 2015")
            trip.destroy if !trip.nil?
        end

#        it 'redirects to the show view' do 
#            post :create, trip: @dummy_trip
#            expect(response).to redirect_to(trip_url(assigns(:trip)))
#        end
    end
end

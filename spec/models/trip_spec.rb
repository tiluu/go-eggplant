require 'rails_helper'

RSpec.describe Trip, type: :model do
	before(:each) do 
		@trip = FactoryGirl.create(:trip)
		@trip2 = FactoryGirl.create(:trip, :trip2)
	end

	after(:each) do
		@trip.destroy
		@trip2.destroy
	end

	let(:invalid_attr) {
		{
			name: @trip.name,
			start_date: @trip.start_date,
			end_date: @trip.end_date,
			city: @trip.city
		}
	}

	describe "valid" do
		it "has a valid factory" do
			expect(@trip).to be_valid
		end

		it "generates a url after trip creation" do
			find_trip = Trip.find_by(url: @trip.url)
			expect(find_trip).to eq(@trip)
		end
	end

	describe "invalid" do
		it "is invalid if any attributes are missing" do
			trip = Trip.create invalid_attr
			expect(trip).to_not be_valid
		end

		it "is invalid if end date is earlier than start date" do
			@trip.update_attribute(:end_date, @trip.start_date - 2)
			expect(@trip).to_not be_valid
		end

		it "raises an error if trip url is not unique" do
			expect {
				@trip.update_attribute(:url, @trip2.url)
				}.to raise_error(ActiveRecord::RecordNotUnique)
		end

		it "rescues RecordNotUnique error" do
			allow(@trip).to receive(:update_attribute)
				.with(:url, @trip2.url)
				.and_raise(ActiveRecord::RecordNotUnique)
			expect {@trip.gen_trip_url}.to_not raise_error
		end

		it "rescues RecordNotUnique error by generating urls" do
			allow(@trip).to receive(:update_attribute)
				.with(:url, @trip2.url)
				.and_raise(ActiveRecord::RecordNotUnique)
			@trip.gen_trip_url
			expect(@trip.url).to_not eq(@trip2.url)
		end
	end
end

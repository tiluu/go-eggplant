require 'rails_helper'

RSpec.describe User, type: :model do
	before(:all) do
		@user = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user2)
	end

	after(:all) do
		@user.destroy
	end

	let(:invalid_attr) {
		{
			name: @user2.name,
			email: @user2.email
		}
	}

	describe "valid" do 
		it 'has a valid factory' do
			expect(@user).to be_valid
		end

		it 'registered user' do
			find_user = User.registered?(@user)
			expect(find_user).to be true
		end
	end

	describe "invalid" do 
		it 'raises an error if any attributes are missing' do
			user = User.create invalid_attr
			expect(user).not_to be_valid
		end

		it 'raises an error if tag is not unique' do
			expect {
				@user.update_attribute(:tag, @user2.tag)
				}.to raise_error(ActiveRecord::RecordNotUnique)
		end

		it 'tag generation method rescues RecordNotUnique error by regenerating tags' do
			allow(@user).to receive(:update_attribute)
				.with(:tag,@user2.tag)
				.and_raise(ActiveRecord::RecordNotUnique)
			expect {@user.gen_user_tag}.to_not raise_error
		end
	end

	describe "authentication" do
		it 'authenticates the user and returns user given a correct email&pw' do 
			login = User.authenticate(@user.email, @user.password)
			expect(login).to eq(@user)
		end
	end

end

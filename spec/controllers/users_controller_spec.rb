require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    before(:each) do
        @user = FactoryGirl.create(:user)
    end

    after(:each) do
        @user.destroy
    end

    let(:valid_attr) {
        {
            name: @user.name,
            email: @user.email,
            password: @user.password,
            password_confirmation: @user.password_confirmation
        }
    }

    let(:invalid_attr) {
        {
            name: @user.name,
            email: @user.email,
            password: 'blahlala',
            password_confirmation: 'blahlala'
        }
    }

    describe "#login" do
        it "renders the login view" do
            get :login
            expect(response).to render_template(:login)
        end

        it "redirects to user dashboard if valid params" do
            post :authenticate, valid_attr
            expect(response).to redirect_to(dashboard_path)
        end

        it "assigns the session id to the current user's id once logged in" do
            post :authenticate, valid_attr
            expect(session[:user_id]).to eq(@user.id)
        end

        it "renders the login view if invalid params" do
            post :authenticate, invalid_attr
            expect(response).to render_template(:login)
        end

        it "shows a flash error message if invalid params" do
            post :authenticate, invalid_attr
            expect(flash[:danger]).to be_present
        end
    end

    describe "#logout" do
        it "deletes the session id" do
            delete :logout
            expect(session[:user_id]).to be_nil
        end

        it "redirectts to the home page once logged out" do
            delete :logout
            expect(response).to redirect_to(root_path)
        end
    end

    describe "#new" do
    end

    describe "#create" do
    end
    
    describe "#show" do
    end

    describe "#edit" do
    end

    describe "#update" do
    end

    describe "#destroy" do
    end
end

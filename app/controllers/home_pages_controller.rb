class HomePagesController < ApplicationController
    def home
      @user = User.new
      @action = 'create'
    	if current_user
    		redirect_to dashboard_path
    	end
    end
end

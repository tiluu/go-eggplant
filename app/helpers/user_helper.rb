module UserHelper
 def getUser
    if current_page?(action: 'edit') || !@current_user.nil?
        @current_user
    elsif current_page?(action: 'new') || @user.errors
        @user
    end
 end 
 
 def getPath(ctrl)
    if current_page?(controller: ctrl, action: 'edit') || !@current_user.nil?
        ctrl === 'users' ? user_account_path : edit_trip_path(@trip.url)
    elsif current_page?(ctrl, action: 'new') || @user.errors || @trip.errors
        ctrl === 'users' ? signup_path : new_trip_path
    end
 end

end


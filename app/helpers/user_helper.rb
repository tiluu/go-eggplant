module UserHelper
 def getUser
    if current_page?(action: 'edit') || !@current_user.nil?
        @current_user
    elsif current_page?(action: 'new') || @user.errors
        @user
    end
 end 
 
 def getPath(ctrl, action)
    curr_pg = current_page?(controller: ctrl, action: action) 
    case ctrl
    when 'users'
       action === 'new' || action === 'create' ? signup_path : user_account_path 
    when 'trips'
       action === 'new' || action === 'create' ? new_trip_path : edit_trip_path(@trip.url)
    end
 end

end


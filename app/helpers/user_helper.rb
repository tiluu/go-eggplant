module UserHelper
 def getUser
    if current_page?(action: 'edit') || !@current_user.nil?
        @current_user
    elsif current_page?(action: 'new') || @user.errors
        @user
    end
 end 
 
 def getPath(ctrl, action)
    {controller: ctrl, action: action}   
 end

end


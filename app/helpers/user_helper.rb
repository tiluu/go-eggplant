module UserHelper
 def getUser
    if current_page?(action: 'edit') || !@current_user.nil?
        @current_user
    elsif current_page?(action: 'new') || @user.errors
        @user
    end
 end 
 
 def getPath
    if current_page?(action: 'edit') || !@current_user.nil?
        user_account_path
    elsif current_page?(action: 'new') || @user.errors
        signup_path
    end
 end

end


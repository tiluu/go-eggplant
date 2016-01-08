module UserHelper
 def which_user
    if current_page?(action: 'edit') || !@current_user.nil?
        @current_user
    elsif current_page?(action: 'new') || @user.errors
        @user
    end
 end

 def getUser(invite)
 	User.find(invite.user_id)
 end
 
end


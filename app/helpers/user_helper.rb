module UserHelper
 def which_user
    if current_page?(controller: 'users', action: 'edit') || !@current_user.nil?
        @current_user
    elsif current_page?(controller: 'home_pages', action: 'home') || @user.errors
        @user
    end
 end
 
end


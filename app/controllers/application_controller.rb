class ApplicationController < ActionController::Base
    def require_admin
        redirect_to '/index' unless current_user.admin?
    end

    def require_editor
        redirect_to '/index' unless current_user.editor?
    end

    helper_method :current_user 
 
    def current_user 
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end 

    def require_user 
        redirect_to '/login' unless current_user 
    end 

    def user_exists
            #redirect user if he is logged in and he wants to visit log in page again
            #check if session[:user_id] is not empty
            redirect_to '/index' unless current_user.blank?
    end
end

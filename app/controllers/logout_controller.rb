class LogoutController < ApplicationController
    
    before_action :current_user, only: [:destroy]

    def destroy
        session[:user_id] = nil
        redirect_to '/index'
    end

end

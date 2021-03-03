class LoginController < ApplicationController
    before_action :user_exists, only: [:login, :create]
    
    def login
    end

    def create
        
        if !params[:log][:username].blank? && !params[:log][:password].blank? 

            @user = User.find_by_username(params[:log][:username])
            
            if @user && @user.authenticate(params[:log][:password])
                session[:user_id] = @user.id
                redirect_to '/index'
            else 
                flash[:notice] = 'Ops try again!'
                redirect_to '/login'
            end

        else
            flash[:notice] = 'Username or password must not be empty!'
            redirect_to '/login'
        end
    end
end

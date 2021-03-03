class RegisterController < ApplicationController
    before_action :user_exists, only: [:register, :create]

    def register
    end

    def create

        if !params[:reg][:first_name].blank? && !params[:reg][:last_name].blank? && !params[:reg][:username].blank? && !params[:reg][:email].blank? && !params[:reg][:password].blank?
            
            @user = User.new(user_params)

            begin 
                
                if @user.save
                    session[:user_id] = @user.id
                    redirect_to '/index'
                else
                    flash[:notice] = 'Something went wrong try again.'
                    redirect_to '/register'
                end

            rescue

                flash[:notice] = 'username or email already exists!'
                redirect_to '/register'

            end

        else 
            flash[:notice] = 'You must fill all fields'
            redirect_to '/register'
        end

    end

    private def user_params
           
        params.require(:reg).permit(:first_name, :last_name, :email, :username, :password)

    end

end

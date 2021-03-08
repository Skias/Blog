class CreateMessageController < ApplicationController
    before_action :require_user, only: [:create_message, :create]

    def create_message
    end

    def create
        
       @parameters =  params.require(:mess).permit(:title, :description, :image)

        @message = Message.new(@parameters.title, @parameters.description)

        @parameters.image
        
        if !@message.title.blank? && !@message.description.blank?
            
            begin

                @message.user_id = session[:user_id]

                if @message.save
                    flash[:notice] = 'Your blog message has been created!'
                    redirect_to '/create_message'
                else
                    flash[:notice] = 'Something went wrong try again!'
                    redirect_to '/create_message'
                end
                
            rescue
               flash[:notice] = 'Maybe there is a problem with the server, try again later!'
                redirect_to '/create_message'
            end

        else 
            flash[:notice] = 'Title or Description must not be empty!'
            redirect_to '/create_message' 
        end

    end

end

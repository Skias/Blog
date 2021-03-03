class BlogController < ApplicationController

    def index
        @messages = Message.all
    end
    
    def show

        begin
            
            @message = Message.find(params[:id])
            @review = Comment.where(:message_id => @message.id)
            
        rescue
            flash[:notice] = 'Message was not found.'
            redirect_to '/index'
        end
        
    end

end

class BlogController < ApplicationController

    def index

        @messages = Message.all
        
    end
    
    def show

        begin
            
            @message = Message.find(params[:id])
            @review = Comment.where(:message_id => @message.id)
            @image = Image.where(:message_id => @message.id)
            
        rescue
            flash[:notice] = 'Blog post was not found.'
            redirect_to '/index'
            return
        end
        
    end

end

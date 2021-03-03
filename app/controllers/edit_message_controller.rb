class EditMessageController < ApplicationController
    before_action :require_user, only: [:edit_message, :edit, :update, :delete]

    def edit_message
        begin

            @messages = Message.where(:user_id => session[:user_id])

        rescue
            flash[:notice] = 'Blog post was not found'
        end
    end

    def edit
        begin
            @messages = Message.where(:user_id => session[:user_id], :id => params[:id])
            if @messages.blank?
                flash[:notice] = 'Blog post was not found.'
                redirect_to '/edit_message'
            end
        rescue
            flash[:notice] = 'Blog post was not found.'
        end
    end

    def update
        begin    
            @message = Message.where(:user_id => session[:user_id], :id => params[:id])

            if @message.update(message_attributes)
                flash[:notice] = 'Blog Message has been updated!'
                redirect_to '/edit_message'
            else
                flash[:notice] = 'Blog post was not updated.'
                redirect_to '/edit_message'
            end

        rescue
            flash[:notice] = 'Blog post was not updated.'
            redirect_to '/edit_message'
        end
    end

    private def message_attributes
        params[:update].permit(:title, :description)
    end

    def delete

        @del_message = Message.where(:user_id => session[:user_id], :id => params[:id])
        @del_comment = Comment.where(:message_id => @del_message)

        if @del_message[0].blank?
             flash[:notice] = 'Blog post was not found.'
             redirect_to '/edit_message'
        else
            @del_comment.destroy_all
            @del_message.destroy_all
            flash[:notice] = 'Post Deleted'
            redirect_to '/edit_message'
        end

    end
end

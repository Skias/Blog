class ReviewController < ApplicationController
    before_action :require_user, only: [:update, :create, :edit, :delete]
    def create

        @reviews = Comment.new(rev_attributes)

        #check if user is correct and blog id
                
        @reviews.user_id = session[:user_id]
        @reviews.message_id = params[:id]

        if @reviews.save
            flash[:notice] = 'Posted'
            redirect_to "/index/#{params[:id]}"
            return
        else
            flash[:notice] = 'Not posted'
            redirect_to "/index/#{params[:id]}"
            return
        end
    end

    private def rev_attributes
        params[:rev].permit(:review)
    end

    def edit
        @review = Comment.find(params[:id])
    end

    def update
        begin    
            @message = Comment.where(:user_id => session[:user_id], :id => params[:id])

            if @message.update(message_attributes)
                flash[:notice] = 'review has been updated!'
                redirect_to "/review/#{params[:id]}"
                return
            else
                flash[:notice] = 'Comment updated.'
                redirect_to "/review/#{params[:id]}"
                return
            end

        rescue
            flash[:notice] = 'Here.'
            redirect_to "/review/#{params[:id]}"
            return
        end
    end

    private def message_attributes
        params[:rev].permit(:review)
    end

    def delete
        @del_message = Comment.where(:user_id => session[:user_id], :id => params[:id])
        
        if @del_message[0].blank?
             flash[:notice] = 'Blog comment was not found.'
             redirect_to "/index"
             return
        else
            @del_message[0].destroy
            redirect_to "/index/#{params[:id]}"
            return
        end
    end
end

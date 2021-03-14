class EditMessageController < ApplicationController
    before_action :require_user, only: [:edit_message, :edit, :update, :delete]

    def edit_message
        begin
            @messages = Message.where(:user_id => session[:user_id])
        rescue
            flash[:notice] = 'Blog post was not found'
            return
        end
    end

    def edit
        begin
            @messages = Message.where(
                :user_id => session[:user_id],
                 :id => params[:id]
                )

            if @messages.blank?
                flash[:notice] = 'Blog post was not found.'
                redirect_to '/edit_message'
                return
            end

            @change_image = Image.where(
                :user_id => session[:user_id],
                :message_id => @messages
                )

        rescue
            flash[:notice] = 'Blog post was not found.'
            return
        end
    end

    def update
            
        @message = Message.where(:user_id => session[:user_id], :id => params[:id])

        @edit_message_params = params[:update].permit(:title, :description, :delete_image, :image)
            
        # If :image is set and :delete_image is set to 'yes'
        # it is useless to do a delete because if :image is set
        # we delete the image and change the path in the database to new one
        # ONLY one image is alloed per blog post

        if !@edit_message_params['image'].blank?
            #If @edit_message_params['image'] has a value we suppose
            #the user wants to change the image
                

            #check file size, 1MB and less
            if File.size(@edit_message_params['image']) > 1024000 #in bytes
                flash[:notice] = 'File size must be less than 1MB'
                redirect_to "/edit_message/#{params[:id]}"
                return
            end

            #check file format
            accepted_formats = ['.jpg','.png']
            if !accepted_formats.include? File.extname(@edit_message_params['image'])
                flash[:notice] = 'File format is not correct'
                redirect_to "/edit_message/#{params[:id]}"
                return
            end

            #check if user file exists for storing images later
            if !File.exist?("app/assets/images/#{session[:user_id]}")

                Dir.mkdir(Rails.root.join('app', 'assets','images',"#{session[:user_id]}"))
                
            end

            #check if Blog file exists for storing images later
            if !File.exist?("app/assets/images/#{session[:user_id]}/#{@message[0]['id']}")

                Dir.mkdir(Rails.root.join('app', 'assets','images',"#{session[:user_id]}/#{@message[0]['id']}"))
            
            end

            #check if image given already exists
            if File.exist?("app/assets/images/#{session[:user_id]}/#{@message[0]['id']}/@edit_message_params['image'].original_filename")

                @change_image = Image.where(
                    :user_id => session[:user_id],
                    :message_id => params[:id]
                )

                #Check if old image exists
                #if old image exists update
                #else create new one

                if !@change_image[0].blank?
                            
                    File.delete("app/assets/images/#{@change_image[0]['image_path']}")

                    @change_image.update(:image_path => "#{session[:user_id]}/#{@message[0]['id']}/#{@edit_message_params['image'].original_filename}")
                    @message.update(:title => @edit_message_params['title'], :description => @edit_message_params['description'])

                    File.open(Rails.root.join('app', 'assets','images',"#{session[:user_id]}", "#{@message[0]['id']}", @edit_message_params['image'].original_filename), 'wb') do |file|
                        file.write(@edit_message_params['image'].read)
                    end

                    flash[:notice] = 'Blog post has been updated'
                    redirect_to '/edit_message'
                    return

                else #image does not exist so create one

                    @new_image = Image.new(
                        :image_path => "#{session[:user_id]}/#{@message[0]['id']}/#{@edit_message_params['image'].original_filename}",
                        :user_id => session[:user_id],
                        :message_id => params[:id]
                    )

                    @new_image.save
                    @message.update(:title => @edit_message_params['title'], :description => @edit_message_params['description'])
                    
                    File.open(Rails.root.join('app', 'assets','images',"#{session[:user_id]}","#{@message[0]['id']}", @edit_message_params['image'].original_filename), 'wb') do |file|
                    file.write(@edit_message_params['image'].read)
                    end
                            
                    flash[:notice] = 'Blog post has been updated'
                    redirect_to '/edit_message'
                    return 

                    end
            else
                flash[:notice] = 'Image already exists'
                redirect_to "/edit_message/#{@message[0]['id']}"
                return
            end
        end
            
            #Here is just to delete image

            if @edit_message_params['delete_image'] == 'yes' && @edit_message_params['image'].blank?
                
                @delete_the_image = Image.where(:user_id => session[:user_id], :message_id => params[:id])
                
                if !File.delete("app/assets/images/#{@delete_the_image[0]['image_path']}")

                    flash[:notice] = 'Something went wrong!'
                    redirect_to '/edit_message'
                    return

                else

                    @delete_the_image.destroy(@delete_the_image[0]['id'])

                    @message.update(:title => @edit_message_params['title'], :description => @edit_message_params['description'])
                        
                    flash[:notice] = 'Image has been deleted successfuly'
                    redirect_to '/edit_message'
                    return

                end

            end
            
            if @message.update(:title => @edit_message_params['title'], :description => @edit_message_params['description'])
                flash[:notice] = 'Blog Message has been updated!'
                redirect_to '/edit_message'
                return
            else
                flash[:notice] = 'Blog post was not updated.'
                redirect_to '/edit_message'
                return
            end
        
    end

    def delete

        @del_message = Message.where(:user_id => session[:user_id], :id => params[:id])
        

        if @del_message[0].blank?
             flash[:notice] = 'Blog post was not found.'
             redirect_to '/edit_message'
             return
        else
            @del_image = Image.where(:message_id => @del_message)
            @del_comment = Comment.where(:message_id => @del_message)

            if !@del_image.blank? && File.exist?("app/assets/images/#{@del_image[0]['image_path']}")

                File.delete("app/assets/images/#{@del_image[0]['image_path']}")
                Dir.rmdir("app/assets/images/#{session[:user_id]}/#{@del_message[0]['id']}")

            end

            @del_comment.destroy_all
            @del_image.destroy_all
            @del_message.destroy_all

            flash[:notice] = 'Post Deleted'
            redirect_to '/edit_message'
            return
        end

    end
end

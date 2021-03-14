class CreateMessageController < ApplicationController
    before_action :require_user, only: [:create_message, :create]

    def create_message
    end

    def create
        
        @create_message_params = params.require(:mess).permit(:title, :description, :image)
        
        if !@create_message_params['title'].blank? && !@create_message_params['description'].blank?
            

            if !@create_message_params['image'].blank?

                if File.size(@create_message_params['image']) > 1024000 #in bytes 
                    flash[:notice] = 'File size must be less than 1MB'
                    redirect_to '/create_message'
                    return
                end

                accepted_formats = ['.jpg','.png']
                #CHECK IF IMAGE HAS CORRECT FORMAT
                if !accepted_formats.include? File.extname(@create_message_params['image'])
                    flash[:notice] = "Image type must be .jpg or .png"
                    redirect_to '/create_message'
                    return
                end

                    #CHECK IF USER FOLDER EXISTS ELSE WE HAVE TO CREATE ONE
                if !File.exist?("app/assets/images/#{session[:user_id]}")

                    Dir.mkdir(Rails.root.join('app', 'assets','images',"#{session[:user_id]}"))
                
                end

                @message = Message.new(
                    :title => @create_message_params['title'],
                    :description => @create_message_params['description'],
                    :user_id => session[:user_id]
                )
            
                if @message.save
                    
                    #Create blog folder to store images
                    Dir.mkdir(Rails.root.join('app', 'assets','images',"#{session[:user_id]}", "#{@message.id}"))
                    
                    File.open(Rails.root.join('app', 'assets','images',"#{session[:user_id]}", "#{@message.id}", @create_message_params['image'].original_filename), 'wb') do |file|
                        file.write(@create_message_params['image'].read)
                    end

                    @blog_image = Image.new(
                        :image_path => "#{session[:user_id]}/#{@message.id}/#{@create_message_params['image'].original_filename}",
                        :user_id => session[:user_id],
                        :message_id => @message.id
                    )
                                
                    @blog_image.save

                    flash[:notice] = 'Your blog message has been created!'
                    redirect_to '/create_message'
                    return

                else
                    flash[:notice] = 'Something went wrong try again!'
                    redirect_to '/create_message'
                    return
                end
            end

            #GO HERE ONLY IF IMAGE IS NOT GIVEN
            begin

                @message = Message.new(
                    :title => @create_message_params['title'],
                    :description => @create_message_params['description'],
                    :user_id => session[:user_id]
                );

                if @message.save
                    flash[:notice] = 'Your blog message has been created!'
                    redirect_to '/create_message'
                    return
                else
                    flash[:notice] = 'Something went wrong try again!'
                    redirect_to '/create_message'
                    return
                end
                
            rescue
                flash[:notice] = 'Maybe there is a problem with the server, try again later!'
                redirect_to '/create_message'
                return
            end

        else 
            flash[:notice] = 'Title or Description must not be empty!'
            redirect_to '/create_message'
            return
        end

    end

end

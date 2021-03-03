Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #main page
  root 'blog#index'
  
  #show blog posts without the need to be logged in
  get '/index' => 'blog#index'
  get '/index/:id' => 'blog#show', as: :mess #:mess refers to message it is just cut to mess
  
  #log in and register user, users are automatically assigned the role of editor
  get '/register' => 'register#register'
  get '/login' => 'login#login'

  # create blog post
  get '/create_message' => 'create_message#create_message'

  # all about editing blog post
  get '/edit_message' => 'edit_message#edit_message'
  get '/edit_message/:id' => 'edit_message#edit', as: :ed #:ed refers to edit it is just cut to ed
  post '/edit_message/:id' => 'edit_message#update'
  delete '/edit_message/:id' => 'edit_message#delete'

  delete '/logout' => 'logout#destroy' #log out function
  
  #all about reviews
  get '/review/:id' => 'review#edit'
  delete '/review/:id' => 'review#delete'
  post '/index/:id' => 'review#create'
  post '/review/:id' => 'review#update'
  
  
  post '/login' => 'login#create' #user log in function
  post '/register' => 'register#create' #user register function
  post '/create_message' => 'create_message#create' #creation of blog post

end

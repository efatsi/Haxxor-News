HaxxorNews::Application.routes.draw do

	resources :articles do
    resources :comments
    post 'upvote' => 'votes#create', :direction => 'up'
    post 'downvote' => 'votes#create', :direction => 'down'
	end
	
  resources :comments do
    resources :comments
    post 'upvote' => 'votes#create', :direction => 'up'
    post 'downvote' => 'votes#create', :direction => 'down'
  end

	resources :users do
	  get 'upvotes' => 'votes#index', :direction => "up"
  end
  
	resources :sessions
	
	resources :password_resets
	resources :pick_dates
	
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'
	match 'welcome' => 'users#welcome'
	match 'user/:id/upvotes' => 'users#upvotes', :as => :upvotes
	match 'user/:id/change_password' => 'users#change_password', :as => :change_password
	
	# Change root path
	# This does normal load
	root :to => 'articles#index'


end

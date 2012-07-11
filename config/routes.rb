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
	

	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login
	match 'welcome' => 'users#welcome', :as => :welcome
	match 'article/pick_date' => 'articles#pick_date', :as => :pick_date
	match 'user/:id/change_password' => 'users#change_password', :as => :change_password
	
	# Change root path
	# This does normal load
	root :to => 'articles#index'


end

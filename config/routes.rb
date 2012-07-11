HaxxorNews::Application.routes.draw do

  resources :articles
  resources :comments
  
	resources :articles do
    resources :comments
  	post :upvote, :on => :member
  	post :downvote, :on => :member
	end
	
  resources :comments do
    resources :comments
  	post :upvote, :on => :member
  	post :downvote, :on => :member
  end

	resources :users
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

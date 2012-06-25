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

	match 'user/edit' => 'users#edit', :as => :edit_current_user
	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login
	match 'welcome' => 'users#welcome', :as => :welcome
	match 'user/:id/upvotes' => 'users#upvotes', :as => :upvotes
	
	# Change root path
	# This does normal load
	root :to => 'articles#index'


end
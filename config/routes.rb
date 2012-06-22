HaxxorNews::Application.routes.draw do

  resources :articles
  resources :comments
  
	resources :articles do
    resources :comments
  end
  resources :comments do
    resources :comments
  end

	resources :users
	resources :sessions
	
	resources :password_resets
  resources :users do
    get "reset_password", on: :member
  end


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

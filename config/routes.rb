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

	match 'user/edit' => 'users#edit', :as => :edit_current_user
	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login
	match 's_login' => 'sessions#snew', :as => :s_login
	match 'welcome' => 'users#welcome', :as => :welcome
	
	# Change root path
	root :to => 'articles#index'


end

HaxxorNews::Application.routes.draw do


  resources :comments

  resources :articles

	# Change root path
	root :to => 'articles#index'
	
	resources :users
	resources :sessions
	
	match 'user/edit' => 'users#edit', :as => :edit_current_user
	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login
	match 's_login' => 'sessions#snew', :as => :s_login
	match 'welcome' => 'users#welcome', :as => :welcome
	

end

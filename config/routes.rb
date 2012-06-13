HaxxorNews::Application.routes.draw do


  resources :articles

	# Change root path
	root :to => 'articles#index'
	
	resources :users
	resources :sessions
	match 'user/edit' => 'users#edit', :as => :edit_current_user
	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login
	

end

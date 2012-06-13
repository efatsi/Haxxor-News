HaxxorNews::Application.routes.draw do


  match 'home' => 'home#home', :as => :home
	# Change root path
	root :to => 'home#home'
	
	resources :users
	resources :sessions
	match 'user/edit' => 'users#edit', :as => :edit_current_user
	match 'signup' => 'users#new', :as => :signup
	match 'logout' => 'sessions#destroy', :as => :logout
	match 'login' => 'sessions#new', :as => :login
	

end

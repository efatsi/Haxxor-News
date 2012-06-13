HaxxorNews::Application.routes.draw do

  resources :users

  match 'home' => 'home#home', :as => :home
	# Change root path
	root :to => 'home#home'
	

end

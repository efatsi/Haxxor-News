class SessionsController < ApplicationController
  
  skip_before_filter :store_location

	def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
    	flash[:notice] = "Welcome, #{current_user.username}!"
  	  redirect_back_or_default(articles_path)
    else
    	flash.now.alert = "Email or password is invalid."
      render :action => "new"
    end    
  end

  def destroy
    cookies.delete(:auth_token)
  	redirect_to articles_path, notice: "Logged out!"
  end
	
end

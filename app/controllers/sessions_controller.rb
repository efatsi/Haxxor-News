class SessionsController < ApplicationController

	def new
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
    	session[:user_id] = user.id
  	  redirect_to articles_path, notice: 'Logged In!'
    else
    	flash.now.alert = "Email or password is invalid."
      render :action => "new"
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to articles_path, notice: "Logged out!"
  end
	
end

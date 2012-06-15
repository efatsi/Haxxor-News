class SessionsController < ApplicationController

	def new
  end
  
  def create
    if User.authenticate(params[:username], params[:password])
    	session[:user_id] = User.find_by_username(params[:username]).id
    	flash[:notice] = "Logged In!"
  	  redirect_back_or_default(articles_path)
    else
    	flash.now.alert = "Email or password is invalid."
      render :action => "new"
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to articles_path, notice: "Logged out!"
  end
  
  def destroy2
  	session[:user_id] = nil
  	redirect_to articles_path
  end
	
end

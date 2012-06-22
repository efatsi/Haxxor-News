class UsersController < ApplicationController
  
  skip_before_filter :store_location, :only => [:new, :create, :update]

  load_and_authorize_resource
  
	def new
    @user = User.new
  end

  def edit
    @user = current_user
  end
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
    	session[:user_id] = @user.id
    	cookies[:auth_token] = @user.auth_token
      redirect_to(@user, :notice => 'Welcome to Haxxor News, we recommend you fill in the following information. i.e. email for password retrieval.')
    else
      render :action => "new"
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => "You've successfully updated your information!")
    else
      render :action => "edit"
    end
  end
  
  def change_password 
    @user = User.find(params[:id]) 
    if request.post? 
      if User.authenticate(@user.username, params[:password][:old_password]) == @user 
        @user.password = params[:password][:new_password] 
        @user.password_confirmation = params[:password][:new_password_confirmation] 
        if @user.save  
          redirect_to @user, :notice => 'Your password has been changed.'
        elsif params[:password][:new_password] != params[:password][:new_password_confirmation]
          redirect_to change_password_path, :alert => 'New password and confirmation were not the same.'
        else 
          redirect_to change_password_path, :alert => 'Unable to change your password.' 
        end 
      else 
        redirect_to change_password_path, :alert => 'Old password incorrect.' 
      end 
    end 
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end  
	
end

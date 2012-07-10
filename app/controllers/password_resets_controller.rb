class PasswordResetsController < ApplicationController
  
  skip_before_filter :store_location
  
  def new
    @password_reset = PasswordReset.new
  end
  
  def create
    @password_reset = PasswordReset.new(params[:password_reset])
    if @password_reset.save
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      render :new
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    @password_reset = PasswordReset.new(:user => @user)
    if @password_reset.expired?
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    else
      log_user_in
    end
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    @password_reset = PasswordReset.new(:user => @user)
    
    if @password_reset.update(params[:password_reset])
      redirect_to root_url, :notice => "Password has been reset, hurray!"
    else
      flash.now.alert = "Pleaser enter a new Password and Confirmation"
      render :edit
    end
    
  end
  
  private
  
  def log_user_in
    cookies[:auth_token] = @user.auth_token
  end
  
end

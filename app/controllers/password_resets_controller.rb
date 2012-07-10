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
    @password_reset = PasswordReset.find(params[:id])
    if @password_reset.expired?
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    end
  end

  def update
    @password_reset = PasswordReset.find(params[:id])
    if @password_reset.update_attributes(params[:password_reset])
      redirect_to root_url, :notice => "Password has been reset, hurray!"
    else
      render :edit
    end
    
  end
end

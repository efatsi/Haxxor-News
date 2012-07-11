class PasswordResetsController < ApplicationController
  
  skip_before_filter :store_location
  before_filter :assign_password_reset, :only => [:edit, :update]
  
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
    if @password_reset.expired?
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    end
  end

  def update
    if @password_reset.update_attributes(params[:password_reset])
      redirect_to root_url, :notice => "Password has been reset, hurray!"
    else
      render :edit
    end
  end
  
  private
  def assign_password_reset
    @password_reset = PasswordReset.find(params[:id])
  end
  
end

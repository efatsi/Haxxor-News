class UsersController < ApplicationController
  before_filter :check_login, :except => [:new, :create]

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
      redirect_to(articles_path, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
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

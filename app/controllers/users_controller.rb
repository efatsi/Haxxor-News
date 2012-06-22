class UsersController < ApplicationController
  
  before_filter :require_user, :except => [:new, :create, :welcome]
  skip_before_filter :store_location, :only => [:new, :create, :edit, :update, :destroy, :welcome]

  load_and_authorize_resource
  
	def new
    @user = User.new
  end

  def edit
  end
  
  def index
    @users = User.all
  end

  def show
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
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end  
	
end

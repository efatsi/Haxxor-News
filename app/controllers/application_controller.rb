class ApplicationController < ActionController::Base
  protect_from_forgery
  private
  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
  	current_user
  end
  
  def require_user
    unless current_user
      store_location
      redirect_to login_path, alert: "You need to log in to view this page."
      return false
    end
  end
  
  def store_location
    if request.get? and !request.xhr?
      session[:return_to] = request.url
    end
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  helper_method :current_user, :logged_in?, :require_user, :store_location, :redirect_back_or_default

  ## Only to be used with CanCan ###
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You cannot go here. Since you are not authorized. This is a haiku."
  redirect_to root_url
end
end

require 'my_auth'
require 'my_redirect'

class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  include MyAuth
  include MyRedirect
  
  helper_method :current_user, :logged_in?, :require_user, :store_location, :redirect_back_or_default

  ## Only to be used with CanCan ###
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You cannot go here. Since you are not authorized. This is a haiku."
  redirect_to root_url
  end
end

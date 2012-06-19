class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  include HaxxorNews::Authentication
  
  ## Only to be used with CanCan ###
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You cannot go here. Since you are not authorized. This is a haiku."
  redirect_to root_url
  end
  
end

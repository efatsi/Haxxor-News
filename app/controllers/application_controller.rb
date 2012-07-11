class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  include HaxxorNews::Authentication
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You cannot go here. Since you are not authorized. This is a haiku."
  redirect_to "/articles"
  end
  
  private
  def find_parent_resource
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
end

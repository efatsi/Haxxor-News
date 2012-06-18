module MyRedirect
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
end
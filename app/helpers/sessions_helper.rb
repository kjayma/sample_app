module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user= (user)
    # this one is used to assign current user unconditionally
    @current_user = user
  end

  def current_user
  # this one returns the current user
  # ||= means return current user if it has a value, otherwise call the
  # user_from_remember method. If we haven't switched pages, it will hava a value
  
    @current_user ||= user_from_remember_token
  end
  
  def current_user? (user)
    user == current_user
  end

  def signed_in?
    # when not signed_in ... deny access
    !current_user.nil?
  end

  def authenticate
    # deny_access will redirect to the signon page.
      deny_access unless signed_in?
  end

  def deny_access
    # store the current path before redirecting
    store_location
    # Routes.db resolves signin_path to the SessionsController.new method
    redirect_to signin_path, :notice => "Please sign in to access this page."
    # if sign in is successful, the path will be restored to get the user back
    # to the original page
  end
  
  def sign_out
    cookies.delete (:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    # gets called if signin is successful
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private
  # remember_token is a method that returns an array.  the * operator
  # converts the two element array into a two element parameter list
  # Authenticate expects a parameter list with two strings and not
  # an array of two strings
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end

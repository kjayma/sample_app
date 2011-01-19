module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user= (user)
  # this one is used to set current user
  @current_user = user
  end

  def current_user
  # this one is set to assign current user
  # ||= means assign current user only if it has no value yet. Call the
  # user_from_remember method
  
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete (:remember_token)
    self.current_user = nil
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

end

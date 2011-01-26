class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # sign_in and redirect_back_or methods are located in sessions_helper
      # sign_in sets the cookies with the user_id and salt of the signed_in user
      # and also set the User.current_user class variable.
      sign_in user
      # redirect_back_or redirects to the original page before sign_in was forced, or
      # goes back to a default page if user signed in directly.
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end


end

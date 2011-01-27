class UsersController < ApplicationController
  
  before_filter :authenticate, :only =>[:edit, :update, :index, :destroy]
  # Note: this authenticate method is lower in the UsersController code, but
  # there is another authenticate located in the User.rb model.  This authenticate
  # ensures the user is signed in.  If the user is not already signed in, he/she
  # is directed to the sign-in page.  After the user fills in the sign in page,
  # the User.Rb authenticate checks that the user identified on the sign in page
  # exists.  So they work hand-in-hand.
  before_filter :correct_user, :only =>[:edit, :update]
  before_filter :admin_user, :only =>:destroy
  before_filter :signed_in_user, :only => [:new, :create]
  
 def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
 end

 def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])

 end

 def show
    @user = User.find(params[:id])
    @title = @user.name
 end

 def new 
    @user = User.new
    @title = "Sign up"
 end
  
 def edit
 # the before clause ensures authenticate is triggered before we get here.
 # if not signed on, we go to the sign on page.
 # trace by looking at:
 #    - authenticate method below, 
 #    - signed_in? and deny_access in apps/helpers/sessions_helper,
 #      signed_in checks if there is a current_user. 
 #      checks first if current_user is set, if not, tries to retreive
 #      using remember_token cookie.  If either method finds a current_user, 
 #      continue edit, otherwise, go to the sign in page as follows:
 #    - store_location in sessions_helper, to keep track of the calling url (in this
 #      case, user/#/edit)
 #    - signin_path in routes.db
 #    - new in sessions_controller
 #    - new.html.erb in app/sessions/views
 #    - comments in routes.db, indicating default routing for resources
 #    - create in sessions_controller
 #    - authenticate in Users.rb (this gets the user object associated 
 #      with the sign in info)
 #    - sign_in in sessions_helper (this sets the remember_token cookie and
 #      also sets the User.current_user variable (if we switch pages, it 
 #      gets retrieved using the remember_token cookie)
 #    - redirect_back_or in session_helper (this either goes to the default home
 #      page or returns to the original url, if there was one.  would only work if
 #      the url included the same user number as the user who signs in)
    @user = User.find(params[:id])
    @title = "Edit user"
 end
  
def update
# the before clause ensures authenticate is triggered before we get here.
 # if not signed on, we go to the sign on page.
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
end
 
def destroy
  if (params[:id].to_i == current_user.id)
    flash[:error] = "You cannot destroy yourself"
    redirect_to users_path
  else
    User.find(params[:id]).destroy 
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
end

  private
  
    def authenticate
    # deny_access and signed_in? are methods in helpers/session_helpers
    # deny_access will redirect to the signon page.
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end  
    
    def signed_in_user
      redirect_to(root_path) if signed_in?
    end  
end


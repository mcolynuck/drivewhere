class AccessController < ApplicationController

  layout "admin"
	
  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def index
  end


  def login
  end


  def attempt_login
  	if params[:username].present? && params[:password].present?
  		found_user = User.where(:name => params[:username]).first
  		if found_user
  			authorized_user = found_user.authenticate(params[:password])
  		end
  	end
  	if authorized_user
      if authorized_user.active?
    		# Mark user as logged in
    		session[:user_name] = authorized_user.name
    		session[:user_id] = authorized_user.id
        session[:user_role] = authorized_user.role.name

        # Check if password has expired
        if found_user.expired?
          flash[:warning] = "You must change your password."
          redirect_to(:controller => "users", :action => "changepwd")
        else
      		flash[:notice] = "You are now logged in."
     		  redirect_to(:action => 'index')
        end
    	else
        flash[:error] = "Your account is not active.  Please contact an administrator."
    		redirect_to(:action => 'login')
    	end
    else
      flash[:error] = "Invalid username/password combination."
      redirect_to(:action => 'login')      
    end
  end


  def logout
  	# Mark user as logged out
  	session[:user_name] = nil
  	session[:user_id] = nil
    session[:user_role] = nil
  	flash[:notice] = "Logged out"
  	redirect_to :action => "login"
  end
end
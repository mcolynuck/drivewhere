class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  private 

  def confirm_logged_in
  	unless session[:user_id]
  		flash[:notice] = "Please log in."
  		redirect_to :controller => "access", :action => "login"
  		return false	# Stop any further action
  	end
    
    @user = User.find(session[:user_id])
    unless @user.active?
      flash[:notice] = "This user is not currently active."
      redirect_to :controller => "access", :action => "logout"
      return false
    end
	  return true
  end


  def confirm_admin
    unless session[:user_role] == "admin"
      flash[:error] = "You do not have rights to that page."
      redirect_to :controller => "access", :action => "index"
      return false
    end
    return true
  end

  # Check if admin or owner role and get owner.id accordingly.
  def get_owner_id_for_user
    if session[:user_role] == "admin"   # Admin can do anything so use param.id
      params[:id]
    else
      User.find(session[:user_id]).owner.id   # Owner can only edit their own account
    end
  end  
end

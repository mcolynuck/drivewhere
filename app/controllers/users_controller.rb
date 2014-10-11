class UsersController < ApplicationController
  
  layout "admin"

  before_action :confirm_logged_in
  before_action :confirm_admin, :except => [:changepwd, :setpwd]

  def new
    @user = User.new
    @user.expiry = Time.now

    # Prep other data on form
    @related = get_related
  end


  def create
    @user = User.new(new_user_params)
    @user[:created_by] = session[:user_name]
    @user.role = Role.find(params[:role_id])

    unless @user.role.name == "admin"   # Admin doesn't have an owner
      @user.owner = Owner.find(params[:owner_id])
    end

    if @user.save
      flash[:notice] = "New user created successfully"
      redirect_to(:action => 'show', :id => @user.id)
    else
      flash[:error] = "Failed to create user."
      @related = get_related
      render('new')
    end
  end


  def index
    @users = User.all.newest_last
  end


  def show
    begin
      @user = User.find(params[:id])
    rescue
      flash[:warning] = "Could not find user with id [#{params[:id]}]"
      redirect_to(:action => "index")
      return false
    end
  end


  def edit
    @related = get_related

    unless @user.role.name == "admin"   # Admin doesn't have an owner
      @user.owner = Owner.find(params[:owner_id])
    end

    begin
      @user = User.find(params[:id])
    rescue
      flash[:warning] = "Could not find user with id [#{params[:id]}]"
      redirect_to(:action => "index")
      return false
    end
  end


  def update
    begin
      @user = User.find(params[:id])
    rescue
      flash[:warning] = "Could not find user with id [#{params[:id]}]"
      redirect_to(:action => "index")
      return false
    end


    if(session[:user_role] == "admin")
      # Only an admin can update these values.
      @user.role = Role.find(params[:role_id])    
      @user.owner = Owner.find(params[:owner_id])
      paramList = update_user_params_admin
    else
      paramList = update_user_params
    end

    # Manually update items where controls are not tied to event value (i.e. select options)
    @user[:updated_by] = session[:user_name]   # Indicate who updated this record

    if @user.update_attributes(paramList)
        flash[:notice] = "User updated successfully"
        redirect_to(:action => "show", :id => @user.id)
    else
      flash[:error] = "Could not update user data."
      render 'edit'
      return false
    end
  end


  def changepwd
    # Can only change the ACTIVE session users password, don't use params[:id]!!!
    begin
      @user = User.find(session[:user_id])
    rescue
      flash[:warning] = "Could not find current user data."
      redirect_to(:action => "index")
      return false
    end
#TODO: Should use a project configured interval for expiry!
    @user[:expiry] = 1.year.from_now
  end


  def resetpwd
    @user = User.find(params[:id])
    @user[:expiry] = Time.now   # Will force user to set new password when they log in next.
 #   render 'resetpwd'
  end


  def setpwd
    begin
      @user = User.find(params[:id])
    rescue
      flash[:error] = "Could not find user with id: #{params[:id]}"
      if session[:user_role] == "admin"
        redirect_to(:action => "show", :id => params[:id])
      else
        redirect_to(:controller => "access", :action => "index")
      end
      return false
    end

    @user[:updated_by] = session[:user_name]
    
    if @user.update_attributes(pswd_params)
      flash[:notice] = "Password successfully set"
      if session[:user_role] == "admin"
        redirect_to(:action => "show", :id => @user.id)
      else
        redirect_to(:controller => "access", :action => "index")
      end
    else
      flash[:error] = "Password not changed!"
     if params[:events].expiry.past?   # resetpwd sets expiry to 'now'
       render "resetpwd"
     else
       render 'changepwd'
     end
    end
  end


  def delete
    begin
      @user = User.find(params[:id])
    rescue
      flash[:error] = "Could not find user to delete with id: #{params[:id]}"
      redirect_to(:action => "index")
      return false
    end
  end


  def destroy
    begin
      user = User.find(params[:id]).destroy
      flash[:notice] = "User '#{user.name}' deleted successfully"
      redirect_to(:action => "index")
    rescue
      flash[:error] = "Could not find user to delete with id: #{params[:id]}"
      redirect_to(:action => "index")
      return false
    end
  end


  private   # -------------------------------------------------

  def update_user_params_admin
    params.require(:user).permit(:name, :role, :owner, :expiry, :active, :first_name, :last_name, :phone, :email, :updated_by)
  end

  def update_user_params
    params.require(:user).permit(:name, :expiry, :active, :first_name, :last_name, :phone, :email, :updated_by)
  end

  def new_user_params
    params.require(:user).permit(:name, :role, :owner, :expiry, :active, :password, :password_confirmation, :first_name, :last_name, :phone, :email, :created_by)
  end

  def pswd_params
    params.require(:user).permit(:password, :password_confirmation, :expiry, :updated_by)
  end

  # Get related data needed for display
  def get_related
    data = {:roles => Role.all,
            :owners => Owner.all
    }
  end
end
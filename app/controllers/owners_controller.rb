class OwnersController < ApplicationController

  layout "admin"

  before_action :confirm_logged_in
  before_action :confirm_admin, :except => [:show, :edit, :update]

  def index
#    @owners = Owner.order("name ASC")
    @owners = Owner.all.newest_last
    @owners ||= [Owner.new]   # Should instead return message saying no owners were found.
  end


  def show
    @owner = Owner.find(get_owner_id_for_user)
    if @owner.nil?
      flash[:warning] = "Owner with id: #{id} not found. "
      redirect_to(:action => "index")
    end
  end


  def new
	  @owner = Owner.new
  end


  def create
    @owner = Owner.new(owner_params)

    # Manually set values not allowed by mass assignment.
    @owner.created_by = session[:user_name]

    if @owner.save
      flash[:notice] = "New owner created successfully"
      redirect_to(:action => "index")
    else
      flash[:error] = "Failed to save user record."
      render('new')
    end
  end


  def edit
    @owner = Owner.find(get_owner_id_for_user)
    if(@owner == nil) then
      @owner = Owner.new  # Should we need this to show an error message just to keep html code happy?
      flash[:warning] = "Owner with id: #{id} not found. "
    end    
  end


  def update
    @owner = Owner.find(get_owner_id_for_user)
    oparams = owner_params
    oparams[:updated_by] = session[:user_name]   # Indicate who updated this record
    if @owner.update_attributes(oparams)
      flash[:notice] = "Owner updated successfully"
      redirect_to(:action => "show", :id =>@owner.id)
    else
      render('edit')
    end
  end


  def delete
    @owner = Owner.find(params[:id])
  end


  def destroy
    owner = Owner.find(params[:id]).destroy
    flash[:notice] = "Owner '#{owner.name}' deleted successfully"
    redirect_to(:action => "index")
  end


  private

  def owner_params
    # Do not allow timestamps.
    params.require(:owner).permit(:name, :description, :contact_first, :contact_last, :address_1, :address_2, :city, :region, :country, :postal, :phone, :email, :created_by, :updated_by)
  end
end

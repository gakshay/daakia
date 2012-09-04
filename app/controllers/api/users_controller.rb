class Api::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, :except => [:index]
  
  def index
    respond_to do |format|
      format.html 
      format.json  { render :json => current_user }
      format.xml {render :xml => current_user}
    end
  end

  def show
    respond_to do |format|
      format.html 
      format.json  { render :json => @user , :status => :ok}
      format.xml {render :xml => @user}
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.json { head :ok }
    end
  end
  
  def edit
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      respond_to do |format|
        format.html { redirect_to root_path }
        format.xml { render :xml => current_user }
      end
      
    else
      render "edit"
    end
  end


  protected
  def find_user
    @user = current_user 
  end
end


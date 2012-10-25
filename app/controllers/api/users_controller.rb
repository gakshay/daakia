class Api::UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :register
  before_filter :find_user, :except => [:index, :register]
  
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
    respond_to do |format|
      format.html 
      format.xml {render :xml => current_user}
    end
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
      respond_to do |format|
        format.html { render :action => "edit", :id => current_user.id}
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def register
    if !params['sid'].blank? && !params['event'].blank?
      if params['event'] == "NewCall"
        mobile = params['cid']
        @call_log = CallLog.create(:caller => mobile, :sid => params['sid'], :event => "register", :called_number => params['called_number'], :operator => params['operator'], :circle => params['circle'] )
        @status, @message = ["NEW CALL", "Welcome to e Daa kiya"]
      elsif params['event'] == "GotDTMF"
        if params['data'] == "1"
          @call_log = CallLog.find_by_sid(params['sid'])
          @status, @message = @call_log.register_user
        else
          @status, @message = ["INVALID INPUT", "Invalid input"]
        end
      elsif params['event'] == "Disconnect"
        @call_log = CallLog.find_by_sid(params['sid'])
        unless @call_log.blank?
          @call_log.duration = params['total_call_duration']
          @call_log.save
        end
      end
      respond_to do |format|
        format.xml
      end
    end
  end


  protected
  def find_user
    @user = current_user 
  end
end


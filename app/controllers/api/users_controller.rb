class Api::UsersController < ApplicationController
  before_filter :parse_serial_number, :except => [:register, :update_password]
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
        format.xml { render :xml => @user.errors } #, :status => :unprocessable_entity }
      end
    end
  end
  
  def register
    @wait = false
    if !params['sid'].blank? && !params['event'].blank?
      if params['event'] == "NewCall"
        mobile = params['cid']
        @call_log = CallLog.create(:caller => mobile, :sid => params['sid'], :event => "register", :called_number => params['called_number'], :operator => params['operator'], :circle => params['circle'] )
        @status = "NEW CALL"
      elsif params['event'] == "GotDTMF"
        if params['data'] == "1"
          @call_log = CallLog.find_by_sid(params['sid'])
          #@wait = true
          @status = @call_log.register_user
        else
          @status = "INVALID INPUT"
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
  
  
  def parse_serial_number
    error = {}
    if params[:serial_number].blank? || params[:serial_number].length <= 9
      error = {:errors => { :error => "Serial Number is wrong or not provided" }}
    else
      @machine = Machine.find_by_serial_number("#{params[:serial_number]}")
      if @machine.blank?
        error = {:errors => { :error => "This eDakia machine is not registered" }} 
      elsif @machine.retailer.blank?
        error = {:errors => { :error => "This eDakia machine is not installed at any eDakia Kendra" }}
      elsif @machine.retailer.balance < Price::Retailer::MIN_BALANCE
        error = {:errors => { :error => "You have insufficient funds to carry out a transaction" }} 
      end
    end
    unless error.blank?
      respond_to do |format|
        format.xml {render :xml => error } #, :status => :unprocessable_entity}
      end
    end
  end #parse_serial_number
end


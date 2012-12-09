class Api::TransactionsController < ApplicationController
  before_filter :parse_serial_number
  protect_from_forgery :except => [:create, :receive]
  respond_to :xml
  
  
  # POST api/transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.retailer_id = @retailer.id
    @transaction.serial_number = @machine.serial_number
    respond_to do |format|
      if @transaction.save
        @documents = @transaction.documents
        #format.html { redirect_to(@transaction, :notice => 'Mail was successfully sent.') }
        format.xml  
        #format.json  { render :json => @transaction, :status => :created, :location => @transaction }
      else
        @transaction.documents.build
        #format.html { render :action => "new"}
        format.xml  
        #format.json  { render :json => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # Receive /transactions/receive
  def receive
    unless params[:transaction].blank? 
      mobile = params[:transaction][:receiver_mobile]
      email = params[:transaction][:receiver_email]
      secret = params[:transaction][:document_secret]
      @transaction = Transaction.new(params[:transaction])
      if secret.blank?
        @transaction.errors.add(:base, "Doc ID is required") if secret.blank?
      elsif secret.match(/^\d{6}/).blank?
        @transaction.errors.add(:document_secret, "Must be 6 Digit Long") 
      end
      
      if email.blank? && mobile.blank?
        @transaction.errors.add(:base, "Provide Either Mobile number or Email")
      elsif !mobile.blank? && mobile.match(/(^[789]\d{9}$)/).blank?
        @transaction.errors.add(:receiver_mobile, "Invalid Number")
      elsif !email.blank? && email.match(/\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/).blank?
        @transaction.errors.add(:receiver_email, "Invalid Address")
      elsif (!email.blank? && !mobile.blank?)
        @transaction.errors.add(:base, "Enter only Mobile number or Email")
      end
      
      if @transaction.errors.blank?
        @transaction = Transaction.get_document(mobile, email, secret) 
        unless @transaction.blank?
          @documents = @transaction.documents
          user = mobile.blank? ? email : mobile
          @event = @transaction.receive_event(user, @machine.serial_number)
          #@user = User.where("mobile = ? or email = ?", user, user).select("id, mobile, balance").first
        else
          @transaction = Transaction.new(params[:transaction])
          @transaction.errors.add(:base, "Your Document not found")
        end
      end
    else
      @transaction = Transaction.new
    end
    
    if !@transaction.errors.blank? or @transaction.new_record?
      respond_to do |format|
        format.html { render :action =>  "receive", :alert => "Mail Not found"}
        format.xml {render :xml => @transaction.errors} #, :status => :unprocessable_entity}
      end
    else
      respond_to do |format|
        format.html { render :action => "receive", :locals => {:documents => @documents} }
        format.xml #receive.xml 
      end
    end
  end
  
  protected
  
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
      else
        @retailer = @machine.retailer
      end
    end
    unless error.blank?
      respond_to do |format|
        format.xml {render :xml => error} #, :status => :unprocessable_entity}
      end
    end
  end #parse_serial_number
  
  
  
  
end

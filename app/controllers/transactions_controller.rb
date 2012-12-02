class TransactionsController < ApplicationController
  before_filter :authenticate_user!, :except => ["receive", "retailer_txn"]
  before_filter :authenticate_retailer!, :only => "retailer_txn"
  
  # GET /transactions
  # GET /transactions.xml
  def index
    @transactions = Transaction.where("sender_mobile = ? or receiver_mobile = ? or receiver_email = ?", current_user.mobile, current_user.mobile, current_user.email).includes(:documents).order("created_at DESC")
    #print request.env.inspect
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
      format.json  { render :json => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = Transaction.where("id = ? and (sender_mobile = ? or receiver_mobile = ? or receiver_email = ?)  ", params[:id], current_user.mobile, current_user.mobile, current_user.email).first
    unless @transaction.blank?
      respond_to do |format|
        format.html # show.html.erb
        format.xml
        #format.json  { render :json => @transaction }
      end
    end
  end
  
  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.serial_number = params[:serial_number] unless params[:serial_number].blank?
    respond_to do |format|
      if current_user.credit <= 0
         @transaction.errors.add(:base, "You have no credit. Please contact and buy more credit.")
         format.html { redirect_to(new_transaction_url, :alert => @transaction.errors.full_messages.join(". "))}
         format.xml {render :xml => @transaction.errors}
      elsif @transaction.save
        @event = @transaction.send_event(params[:serial_number])
        @document = @transaction.documents.first
        @user = User.find_by_mobile(@transaction.sender_mobile, :select => "id, balance")
        format.html { redirect_to(@transaction, :notice => 'Mail was successfully sent.') }
        format.xml  
        #format.json  { render :json => @transaction, :status => :created, :location => @transaction }
      else
        @transaction.documents.build
        format.html { render :action => "new"}
        format.xml  
        #format.json  { render :json => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = Transaction.new
    1.times do 
      @transaction.documents.build
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end
=begin
  # GET /transactions/1/edit
  def edit
    #@transaction = Transaction.find(params[:id])
    @transaction = Transaction.where("id = ? and (sender_mobile = ? or receiver_mobile = ?)  ", params[:id], current_user.mobile, current_user.mobile)
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    #@transaction = Transaction.find(params[:id])
    @transaction = Transaction.where("id = ? and (sender_mobile = ? or receiver_mobile = ?)  ", params[:id], current_user.mobile, current_user.mobile)

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to(@transaction, :notice => 'Transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    #@transaction = Transaction.find(params[:id])
    @transaction = Transaction.where("id = ? and (sender_mobile = ? or receiver_mobile = ?)  ", params[:id], current_user.mobile, current_user.mobile).first
    Transaction.update(@transaction.id, :active => false)

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
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
        @transaction.errors.add(:document_secret, "is required") if secret.blank?
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
          @event = @transaction.receive_event(user, params[:serial_number])
          @user = User.where("mobile = ? or email = ?", user, user).select("id, mobile, balance").first
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
end

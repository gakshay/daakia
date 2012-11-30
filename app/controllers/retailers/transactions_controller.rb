class Retailers::TransactionsController < ApplicationController
  before_filter :authenticate_retailer!
  
  # GET retailer/transactions
  # GET /transactions.xml
  def index
    @transactions = current_retailer.transactions.order("created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end
  
  # GET retailers/transactions/1
  # GET retailers/transactions/1.xml
  def show
    @transaction = current_retailer.transactions.find(params[:id])
    unless @transaction.blank?
      respond_to do |format|
        format.html # show.html.erb
        format.xml
      end
    end
  end
  
  # DELETE retailers/transactions/1
  # DELETE retailers/transactions/1.xml
  def destroy
    @transaction = current_retailer.transactions.find(params[:id])
    @transaction.update(:active => false)
    @transaction.save!

    respond_to do |format|
      format.html { redirect_to(retailers_transactions_url) }
      format.xml  { head :ok }
    end
  end
  
  
  # GET retailers/transactions/new
  # GET retailers/transactions/new.xml
  def new
    @retailer_transaction = current_retailer.transactions.new
    3.times do 
      @retailer_transaction.documents.build
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end
  
  # POST retailers/transactions
   # POST retailers/transactions.xml
   def create
     @retailer_transaction = current_retailer.transactions.new(params[:transaction])
     respond_to do |format|
       if @retailer_transaction.save
         @event = @retailer_transaction.send_event(params[:serial_number])
         @document = @retailer_transaction.documents.first
         @user = User.find_by_mobile(@retailer_transaction.sender_mobile, :select => "id, balance")
         format.html { redirect_to(@retailer_transaction, :notice => 'Mail was successfully sent.') }
         format.xml  
       else
         format.html { render :action => "new"}
         format.xml  
       end
     end
   end
end

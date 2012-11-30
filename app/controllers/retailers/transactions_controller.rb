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
    2.times do
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
     @retailer_transaction.retailer_id = current_retailer.id
     respond_to do |format|
       if current_retailer.credit <= 0
         @retailer_transaction.errors.add(:base, "You have no credit. Please contact and buy more credit.")
         format.html { redirect_to(new_retailers_transaction_url, :alert => @retailer_transaction.errors.full_messages.join(". "))}
         format.xml {render :xml => @retailer_transaction.errors}
       elsif @retailer_transaction.save
         #@event = @retailer_transaction.send_event(params[:serial_number])
         #@document = @retailer_transaction.documents.first
         format.html { redirect_to(retailers_transactions_url, :notice => 'Mail was successfully sent.') }
         format.xml  
       else
         @retailer_transaction.documents.build
         format.html { render :action => "new"}
         format.xml  
       end
     end
   end
   
   # retailer transactions log
   def retailer_txn
     @txns = current_retailer.events.order("created_at DESC")
     respond_to do |format|
       format.html # receive.html.erb
       format.xml  { render :xml => @transactions }
     end
   end
end

class Api::TransactionsController < TransactionsController
  before_filter :parse_serial_number
  protect_from_forgery :except => [:create, :receive]
  respond_to :xml
  
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
      end
    end
    unless error.blank?
      respond_to do |format|
        format.xml {render :xml => error} #, :status => :unprocessable_entity}
      end
    end
  end #parse_serial_number
  
end

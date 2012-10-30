class Api::TransactionsController < TransactionsController
  before_filter :parse_serial_number
  protect_from_forgery :except => [:create, :receive]
  respond_to :xml
  
  protected
  
  def parse_serial_number
    if params[:serial_number].blank? || params[:serial_number].length <= 9
      xml = {:errors => { :error => "Serial Number is wrong or not not provided" }}
      respond_to do |format|
        format.xml {render :xml => xml, :status => :unprocessable_entity}
      end
    end
  end
end

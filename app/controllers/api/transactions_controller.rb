class Api::TransactionsController < TransactionsController
  before_filter :parse_serial_number
  respond_to :xml, :json
  
  protected
  
  def parse_serial_number
    if params[:serial_number].blank? 
      respond_with :status => :unprocessable_entity
    end
  end
end

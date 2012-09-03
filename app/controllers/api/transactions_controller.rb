class Api::TransactionsController < TransactionsController
  before_filter :parse_serial_number
  protect_from_forgery :except => [:create, :receive]
  respond_to :xml
  
  protected
  
  def parse_serial_number
    if params[:serial_number].blank? || params[:serial_number].length <= 16
      respond_with :status => :unprocessable_entity 
    end
  end
end

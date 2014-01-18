class HomeController < ApplicationController
  before_filter :authenticate_user!, :only =>[:new]

  def index
    if user_signed_in?
      redirect_to transactions_url
    end
    if retailer_signed_in?
      redirect_to retailers_transactions_url
    end
  end
  
  def contact_us
    @contact = Contact.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /thank_you
  def thank_you
    @contact = Contact.new(params[:contact])
    respond_to do |format|
      if @contact.save
        format.html { redirect_to(contact_us_home_index_url, :notice => 'Thanks for contacting us.') }
      else
        format.html { render :action => "contact_us" }
      end
    end
  end
  
  
  
end

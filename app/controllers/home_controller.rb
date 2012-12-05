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
end

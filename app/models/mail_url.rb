class MailUrl < ActiveRecord::Base
  attr_accessible :receiver_url, :sender_url, :transaction_id
  
  belongs_to :transaction
end

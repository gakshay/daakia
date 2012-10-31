# lib/sms.rb

require 'net/http'
require 'net/https'
require 'json'
require 'uri'
#require 'message/smscraze'
require 'message/mobme'
require 'curb'

module Message
  class << self
    def registration_success_template(password, amount, type)
"Registration: Success
Secret PIN: #{password}
Balance: #{amount}/-
Account: #{type}
Welcome to eDakia! Do not share your Secret PIN."
    end
    
    def registration_kyc_success_template(amount, type)
"Success! You are now verified eDakia user.
Balance: #{amount}/-
Account: #{type}
Welcome to eDakia!"
    end
    
    def registration_failed_template
      "Sorry! Your mobile numer is already registered with eDakia."
    end
    
    def document_sender_success_template(cost, secret, receiver, time, balance, url=nil)
"Success!
Txn Fee: #{cost}/-
eDak Code: #{secret}
Recipient: #{receiver}
Timestamp: #{time}
Balance: #{balance}/-
Access your eDak at #{EDAKIA['host']}/receive"
    end
    
    def document_receiver_email_registered_template(sender, secret, time, email, url=nil)
"New eDak received!
From: #{sender}
eDak Code: #{secret}
Timestamp: #{time}
eDak has been sent to #{email} or access at #{EDAKIA['host']}/receive"
    end
    
    def document_receiver_template(sender, secret, time, url=nil)
"New eDak received!
From: #{sender}
eDak Code: #{secret}
Timestamp: #{time}
Access your eDak at #{EDAKIA['host']}/receive"
    end
    
    def document_sender_network_failure_template
      "Sorry! Your eDak sending failed due to network issue."
    end
    
    def document_sender_format_failure_template
      "Sorry! Your eDak sending failed. We currently do not support this file format."                                                     
    end
    
    def document_sender_page_count_failure_template(count = 10)
      "Sorry! Your eDak sending failed. Only #{count} pages are allowed per eDak"
    end
  end
end
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
    def registration_success_template(mobile, password, amount, type)
"Welcome to eDakia! Your number #{mobile} registered

Balance: #{amount} credit
Password: #{password}

Please save and do not share your Password."
    end
    
    def registration_kyc_success_template(amount, type)
"Success! You are now verified eDakia user.
Balance: #{amount} credit
Account: #{type}
Welcome to eDakia!"
    end
    
    def registration_failed_template
      "Sorry! Your mobile numer is already registered with eDakia."
    end
    
    def user_account_balance(mobile, balance, time)
"#{mobile}, your current eDakia Acc Balance is #{balance} as on #{time}."
    end
    
    def document_sender_success_template(cost, secret, receiver, time, balance, url=nil)
"Mail sent.
To: #{receiver}
Doc ID: #{secret}
Txn Fee: #{cost}/-
Account Balance: #{balance}/- on #{time}
Access here #{EDAKIA['host']}/receive"
    end
    
    def document_receiver_email_registered_template(sender, secret, time, email, url=nil)
"Mail received.
From: #{sender}
Doc ID: #{secret}
on #{time}
Check email #{email} or access here #{EDAKIA['host']}/receive"
    end
    
    def document_receiver_template(sender, secret, time, url=nil)
"Mail received.
From: #{sender}
Doc ID: #{secret}
on #{time}
Access here #{EDAKIA['host']}/receive"
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
    
    def retailer_recharge_success(mobile, amount, balance, time)
"eDakia Kendra #{mobile} recharge successful.

Amount Paid: #{amount}/-
Current Balance: #{balance}/-
on #{time}"
    end
    
    def retailer_balance_low(mobile, balance)
"eDakia Kendra #{mobile} current balance #{balance}/- is low.

Please recharge soon for uninteruppted eDakia services"
    end
    
    def retailer_registration(mobile, balance, password, time)
"eDakia Kendra #{mobile} registered.

Current Balance: #{balance}/-
Password: #{password}
on #{time}"
    end
    
    def general_request_received(request, cost, balance)
"#{request} request received.
Txn Fee: #{cost}/-
Account Balance: #{balance}/-

You will be notified soon"
    end
    
    def general_request_replied(request, secret, time, url=nil)
"#{request} request done.

Doc ID: #{secret}
on #{time}
Access here #{EDAKIA['host']}/receive"
    end
  end
end
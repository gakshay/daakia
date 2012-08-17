# lib/sms.rb

require 'net/http'
require 'net/https'
require 'json'
require 'uri'
require 'sms/smscraze'
require 'sms/waysms'
require 'curb'

module SMS
  class << self
    def registration_template(mobile,password)
      "Hi #{mobile}, your eDakia password is #{password}. By Signing up you agree to receive messages from eDakia. Kindle ignore, if not requested"
    end
  
    def document_sender_template(receiver, secret, url)
      "Your document has been sent to #{receiver}. Secret Code is #{secret}. #{url} (eDakia)"
    end
  
    def document_receiver_template(sender, secret, url)
      "Your have received a document from #{sender}. Secret Code is #{secret}. #{url} (eDakia)"
    end
  end
end
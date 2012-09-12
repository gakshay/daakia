# lib/message/smscraze.rb

module Message  
  
  module CrazeConstant
    URL = "http://www.freesmscraze.com/worldwide/send_free_sms_to_india/sms/ussmsscript.php"
    SENDER = "E3D63E"
    RECEIVER = "2933BF"
    MESSAGE = "DF4E58"
    TO = "225FE8"
    PREF = "reff"
    PB1 = "b1"
    B1 = "Send SMS"
    REF = "http://www.freesmscraze.com/worldwide/send_free_sms_to_india/sms/ussms.php"
    REFERER = "http://www.freesmscraze.com/worldwide/send_free_sms_to_india/sms/success_us.php"
    USERAGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.75 Safari/537.1"
    
  end #CrazeConstant
  
  class Smscraze
    attr_accessor :sender, :receiver, :secret, :url, :template
    
    def initialize(sender, receiver, secret, url)
      @sender = sender
      @receiver = receiver
      @secret = secret
      @url = url
    end
    
    def deliver_registration_sms
      @template = Message.registration_template(@sender, @secret) # here secret is the registration password
      send
    end
    
    def deliver_document_sms
      #deliver_sender_sms
      deliver_receiver_sms
    end
    
    def deliver_sender_sms
      @template = Message.document_sender_template(@receiver, @secret, @url)
      send
    end
    
    def deliver_receiver_sms
      @template = Message.document_receiver_template(@sender, @secret, @url)
      puts @template
      send
    end
    
    def send
      c = Curl::Easy.http_post(SMS::CrazeConstant::URL, Curl::PostField.content(SMS::CrazeConstant::SENDER, @sender), Curl::PostField.content(SMS::CrazeConstant::RECEIVER, @receiver), Curl::PostField.content(SMS::CrazeConstant::TO, '+91'), Curl::PostField.content(SMS::CrazeConstant::MESSAGE, @template), Curl::PostField.content(SMS::CrazeConstant::PREF, SMS::CrazeConstant::REF), Curl::PostField.content(SMS::CrazeConstant::PB1, SMS::CrazeConstant::B1) ) do |curl| 
        curl.headers["User-Agent"] = SMS::CrazeConstant::USERAGENT
        curl.headers['Referer'] = SMS::CrazeConstant::REFERER
        curl.verbose = true
      end
      
    end
  end # smscraze
end #Message


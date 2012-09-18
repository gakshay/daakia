# lib/message/mobme.rb

module Message  
  
  module MobmeConstant
    URL = "http://api.fastalerts.in/fastclient/SMSclient.php"
    RECEIVER = "numbers"
    MESSAGE = "message"
    SENDERID = "senderid=EDAKIA"
    USERNAME = "username=#{MOBME_USERNAME}"
    PASSWORD = "password=#{MOBME_PASSWORD}"
    USERAGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.75 Safari/537.1"
    
  end #MobmeConstant
  
  class MobmeServiceError < StandardError
  end
  
  class Mobme
    attr_accessor :receiver, :template
    
    def initialize(receiver, template)
      raise Message::MobmeServiceError, "Receiver not provided." unless (@receiver = receiver)
      raise Message::MobmeServiceError, "Message template not provided." unless (@template = template)
    end
    
    def url
      url = Message::MobmeConstant::URL
      url += "?#{Message::MobmeConstant::SENDERID}"
      url += "&#{Message::MobmeConstant::USERNAME}"
      url += "&#{Message::MobmeConstant::PASSWORD}"
      url += "&#{Message::MobmeConstant::RECEIVER}=#{@receiver}"
      url += "&#{Message::MobmeConstant::MESSAGE}=#{@template}"
      url
    end
    
    def send
      c = Curl::Easy.new(self.url) do |curl| 
        curl.headers["User-Agent"] = Message::MobmeConstant::USERAGENT
        curl.verbose = true
      end
      c.perform
      puts c.body_str
    end
  end # Mobme
end #Message


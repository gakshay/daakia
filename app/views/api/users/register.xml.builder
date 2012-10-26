xml.instruct!
xml.response do
  
  if @wait
    xml.playtext("Please wait and hold the line")
    @status, @message = @call_log.register_user
  end
  
  if @status
    case @status
    when "NEW CALL"
      xml.playtext(@message)
      xml.collectdtmf do 
        xml.playtext("Press 1 to Register")
      end
    when "DUPLICATE"
      xml.playtext(@message)
    when "INVALID MOBILE"
      xml.playtext(@message)
    when "ERROR"
      xml.playtext(@message)
    when "INVALID INPUT"
      xml.playtext(@message)
    when "SUCCESS"
      xml.playtext(@message)
      xml.playtext("You will shortly receive, an S M S with your PIN.")
      xml.playtext("Please do not share your PIN")
    end
  end
  
  xml.playtext("Thank you for calling")
  xml.hangup
end
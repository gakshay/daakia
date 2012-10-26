xml.instruct!
xml.response do
  if @status
    case @status
    when "NEW CALL"
      xml.playtext(@message)
      xml.collectdtmf do 
        xml.playtext("Press 1 to Register")
        xml.playtext("Please wait")
      end
      xml.playtext("Please wait")
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
    end
  end
  xml.playtext("Thank you for calling")
  xml.hangup
end
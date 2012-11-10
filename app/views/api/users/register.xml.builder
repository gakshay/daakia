xml.instruct!
xml.response do
  # 
  # if @wait
  #   xml.playtext("Please wait. Kripya pratiksha kare")
  #   @status = @call_log.register_user
  # end
  
  if @status
    case @status
    when "NEW CALL"
      #xml.playtext("Welcome to e-Daakia. Aapka e-Daakia me swagat hai")
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/welcome_to_edakia.wav")
      if @valid
        xml.collectdtmf do 
          xml.playaudio("https://s3.amazonaws.com/edakia-audio/press_1_to_register.wav", :o => "8000")
        end
      else
        @hung = true
        xml.playaudio("https://s3.amazonaws.com/edakia-audio/sorry_invalid_number.wav")
      end
    when "DUPLICATE"
      @hung = true
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/sorry_already_registered.wav")
    when "INVALID MOBILE"
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/sorry_invalid_number.wav")
    when "ERROR"
      @hung = true
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/error_registration.wav")
    when "INVALID INPUT"
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/pressed_wrong_number.wav")
      xml.collectdtmf do 
        xml.playaudio("https://s3.amazonaws.com/edakia-audio/press_1_to_register.wav", :o => "8000")
      end
    when "SUCCESS"
      @hung = true
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/success_register.wav")
    end
  end
  
  #xml.playtext("Thanks you for Calling. Call karne k liye dhanyawad")
  if @hung 
    xml.playaudio("https://s3.amazonaws.com/edakia-audio/thankyou.wav")
    xml.hangup
  end
end
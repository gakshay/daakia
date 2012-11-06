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
      xml.collectdtmf do 
        #xml.playtext("Please press 1 to register")
        #xml.playtext("Kripya call karne ke liye 1 dabaye.")
        xml.playaudio("https://s3.amazonaws.com/edakia-audio/press_1_to_register.wav")
      end
    when "DUPLICATE"
      #xml.playtext("Sorry, you are already registered. Khed hai, aap pehle se panjikarat upbhokta hai")
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/sorry_already_registered.wav")
    when "INVALID MOBILE"
      xml.playtext("Please call from Mobile Number")
      xml.playtext("Kripya Mobile Number se Call kare")
    when "ERROR"
      #xml.playtext("Sorry, not registered at this time. Khed hai, abhi panjikaran nahi kiya ja sakta")
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/error_registration.wav")
    when "INVALID INPUT"
      #xml.playtext("Sorry, you pressed wrong number. Aapne galat number prekshit kiya hai")
      xml.playaudio("https://s3.amazonaws.com/edakia-audio/pressed_wrong_number.wav")
    when "SUCCESS"
      xml.playtext("You are Successfully Registered, you will shorty receive an SMS with your PASSWORD. Please do not share this PASSWORD with anyone")
      xml.playtext("Aapka Panjikaran safal hua. Ab aapko ek SMS me PASSWORD diya jaega. Kripya yeh PASSWORD kisi bhi vyakti ko na bataye")
    end
  end
  
  #xml.playtext("Thanks you for Calling. Call karne k liye dhanyawad")
  xml.playaudio("https://s3.amazonaws.com/edakia-audio/thankyou.wav")
  xml.hangup
end
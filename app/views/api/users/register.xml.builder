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
      xml.playtext("Welcome to e-Daakia. Aapka e-Daakia me swagat hai")
      xml.collectdtmf do 
        #xml.playtext("Please press 1 to register and wait for sometime")
        xml.playaudio("https://s3.amazonaws.com/edakia-audio/press_1_to_register_english_loud.wav")
        xml.playtext("Panjikaran karne k liye 1 dabaye aur pratiksha kare")
        xml.playaudio("https://s3.amazonaws.com/edakia-audio/press_1_to_register.wav")
      end
    when "DUPLICATE"
      xml.playtext("Sorry, you are already registered. Khed hai, aap pehle se panjikarat upbhokta hai")
    when "INVALID MOBILE"
      xml.playtext("Please call only from Mobile Number. Kripya Mobile Number se Call kare")
    when "ERROR"
      xml.playtext("Sorry, not registered at this time. Khed hai, abhi panjikaran nahi kiya ja sakta")
    when "INVALID INPUT"
      xml.playtext("You pressed wrong number. Aapne galat number prekshit kiya hai")
    when "SUCCESS"
      xml.playtext("You are Successfully Registered, you will shorty receive an SMS with your Secret PIN. Do not share this PIN with anyone")
      xml.playtext("Aapka Panjikaran safal hua. Ab aapko ek SMS me SECRET PIN diya jaega. Kripya yeh PIN kisi bhi vyakti ko na bataye")
    end
  end
  
  xml.playtext("Thanks you for Calling. Call karne k liye dhanyawad")
  xml.hangup
end
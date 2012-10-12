xml.instruct!
xml.response do
  xml.playaudio("https://s3.amazonaws.com/edakia-audio/welcome.wav")
  if @status
    xml.playtext(@message)
  end
  xml.hangup
end
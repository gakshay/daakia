xml.instruct!
xml.response do
  if @status
    xml.playtext(@message)
  end
  xml.hangup
end
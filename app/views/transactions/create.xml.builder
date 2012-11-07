xml.instruct!
xml.transaction do 
  unless @document.blank?
    xml.id(@transaction.id)
    xml.sender_mobile(@transaction.sender_mobile)
    xml.receiver_mobile(@transaction.receiver_mobile)
    xml.receiver_email(@transaction.receiver_email)
    xml.status("eDak sent successfully")
    xml.creation_date(@transaction.created_at.to_date)
    xml.document_url(@document.doc.url(:original, false))
    xml.cost(@transaction.events.where("action = ? or action = ?","send", "save").first.cost)
  else
    xml.error("eDak can not be sent")
    if @transaction
      @transaction.errors.full_messages.each do |err|
        xml.message(err)
      end
    else
      xml.message("Serial number is required")
    end
  end
end

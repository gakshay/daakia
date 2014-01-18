xml.instruct!
xml.transaction do 
  unless @documents.blank?
    xml.id(@transaction.id)
    xml.sender_mobile(@transaction.sender_mobile)
    xml.receiver_mobile(@transaction.receiver_mobile)
    xml.receiver_email(@transaction.receiver_email)
    xml.status("Mail sent successfully")
    xml.creation_date(@transaction.created_at.to_date)
    xml.documents do
      @documents.each do |document|
        xml.document_url(document.doc.url(:original, false))
        xml.document_type(document.doc_content_type)
        xml.document_size("#{document.doc_file_size} B")
      end
    end
    #xml.cost(@transaction.events.where("action = ? or action = ?","send", "save").first.cost)
    xml.cost(@transaction.cost)
  else
    xml.error("Document can not be sent")
    if @transaction
      @transaction.errors.full_messages.each do |err|
        xml.message(err)
      end
    else
      xml.message("Serial number is required")
    end
  end
end

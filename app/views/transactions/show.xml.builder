xml.instruct!
xml.transaction do 
  unless @document.blank?
    xml.id(@transaction.id)
    xml.sender_mobile(@transaction.sender_mobile)
    xml.receiver_mobile(@transaction.receiver_mobile)
    xml.receiver_email(@transaction.receiver_email)
    xml.status("Document found Successfully")
    xml.creation_date(@transaction.created_at.to_date)
    xml.document_url(@document.doc.url(:original, false))
    xml.cost(@transaction.events.where("action = ? or action = ?","send", "save").first.cost)
  else
    xml.error("Document not found")
    xml.message("Two parameters required: transaction[receiver_mobile] and transaction[document_code]")
  end
end

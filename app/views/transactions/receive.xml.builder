xml.instruct!
xml.transaction do 
  unless @document.blank?
    xml.id(@transaction.id)
    xml.status("Mail found Successfully")
    xml.creation_date(@transaction.created_at.to_date)
    xml.document_url(@document.doc.url(:original, false))
    xml.document_type(@document.doc_content_type)
    xml.document_size("#{@document.doc_file_size} B")
    xml.machine(@machine.serial_number)
    unless @user.blank?
      xml.balance(@user.balance)
    end
    xml.cost(@event.cost)
  else
    xml.error("Document not found")
    xml.message("Some error occured")
  end
end

desc "This task is shift old data to new DB scheme"
task :data_shift => :environment do
  transactions = Transaction.all
  transactions.each do |t|
     doc = Document.find(t.document_id) 
     t.document_id = nil
     t.user_id = doc.user_id
     t.save!
     doc.transaction_id = t.id
     doc.user_id = nil
     doc.save!
  end
end
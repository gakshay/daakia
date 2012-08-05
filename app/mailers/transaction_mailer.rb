class TransactionMailer < ActionMailer::Base
  default :from => "akshay@edakia.in"
  
  def welcome_email(user)
    @user = user
    @url = "http://dev.edakia.com:99"
    mail(:to => @user.email, :subject => "Welcome to the eDakia Site")
  end
  
  def send_recipient_email(transaction)
    unless transaction.blank?
      @recipient_email = transaction.receiver_email
      @document_secret = transaction.document_secret
      unless @recipient_email.blank?
        @sender = transaction.sender_mobile
        attachments["#{transaction.document.doc_file_name}"]  = File.read("#{Rails.root}/public#{transaction.document.doc.url.gsub(/\?\d+/, '')}")
        mail(:to => @recipient_email, :from => "#{@sender}@edakia.in", :subject => "New mail from #{@sender}")
      end
    end
  end
end

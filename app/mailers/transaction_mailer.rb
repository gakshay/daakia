class TransactionMailer < ActionMailer::Base
  default :from => "akshay@edakia.in"
  
  def welcome_email(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome to the eDakia")
  end
  
  def send_recipient_email(transaction)
    unless transaction.blank?
      @recipient_email = transaction.receiver_email
      @document_secret = transaction.document_secret
      unless @recipient_email.blank?
        @sender = transaction.sender_mobile
        @document = transaction.documents.first
        #attachments["#{transaction.document.doc_file_name}"]  = File.read("#{transaction.document.doc.url(:original, false)}")
        mail(:to => @recipient_email, :from => "#{@sender}@edakia.in", :subject => "New mail from #{@sender}")
      end
    end
  end
  
  def send_multiple_recipient_emails(transaction)
    unless transaction.blank?
      @transaction = transaction
      @recipient_emails = transaction.receiver_emails
      @document_secret = transaction.document_secret
      @retailer = transaction.retailer
      unless @recipient_emails.blank?
        @sender = transaction.sender_email.blank? ? "#{transaction.sender_mobile}@edakia.in" : transaction.sender_email
        @documents = transaction.documents
        if @transaction.other_domain_sender_email?
          mail(:to => @recipient_emails, :bcc => transaction.retailer.email, :cc => @sender, :from => @sender, :subject => "#{@sender} has sent you an email: eDakia")
        else
          mail(:to => @recipient_emails, :bcc => transaction.retailer.email, :from => @sender, :subject => "#{@sender} has sent you an email: eDakia")
        end
      else
        self.message.perform_deliveries = false
      end
    end
  end
end

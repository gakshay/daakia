class ContactMailer < ActionMailer::Base
  default :to => "akshay@edakia.in"
  
  def contact_us_mail(contact)
    @contact = contact
    mail(:to => "akshay@edakia.in", :from => @contact.email, :subject => "#{contact.name} contacted you.")
  end
end

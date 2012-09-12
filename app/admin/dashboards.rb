ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }
  
  section "All Machines" do
    ul do
      Machine.all.collect do |mac|
        li link_to(mac.serial_number, admin_machine_path(mac))
      end
    end
  end
  
  section "All Retailers" do
    ul do
      Retailer.all.collect do |ret|
        li link_to(ret.mobile, admin_retailer_path(ret))
      end
    end
  end
  
  section "Recent Mails" do
    ul do
      Transaction.order("created_at desc").limit(5).collect do |mail|
        li link_to("To: #{mail.receiver_mobile} From: #{mail.sender_mobile}", admin_transaction_path(mail))
      end
    end
  end

  section "Recent Files" do
    ul do
      Document.order("doc_updated_at desc").limit(5).collect do |doc|
        li link_to(doc.doc_file_name, admin_document_path(doc))
      end
    end
  end
  
  section "Last Users" do
    ul do
      User.order("created_at desc").limit(5).collect do |user|
        li link_to(user.mobile, admin_user_path(user))
      end
    end
  end
  
end

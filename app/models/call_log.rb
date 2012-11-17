class CallLog < ActiveRecord::Base
  attr_accessible :called_number, :caller, :circle, :duration, :event, :operator, :sid
  validates_presence_of :caller
  
  def register_user
    if registered?
      return "DUPLICATE"
    else
      user = User.register_user(self.caller)
      user.blank? ? "ERROR" : "SUCCESS"
    end
  end
  
  def correct?
    !self.caller.match(/(^0?[789][0-9]{9}$)|(^91[789][0-9]{9}$)|(^0091[789][0-9]{9}$)|(^\+?91[789][0-9]{9}$)/i).nil?
  end
  
  def registered?
    self.caller = self.caller[/\d{10}$/]
    user = User.find_by_mobile(self.caller)
    unless user.blank?
      if user.role.name == "basic"
        Report.alert("user", "Deleting user #{user.mobile}")
        user.destroy
        false
      else
        true
      end
    else
      false
    end
  end
end
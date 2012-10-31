class CallLog < ActiveRecord::Base
  attr_accessible :called_number, :caller, :circle, :duration, :event, :operator, :sid
  validates_presence_of :caller
  
  def register_user
    if correct?
      if registered?
        return "DUPLICATE"
      else
        user = User.register_user(self.caller)
        user.blank? ? "ERROR" : "SUCCESS"
      end
    else
      return "INVALID MOBILE"
    end
  end
  
  def correct?
    !self.caller.match(/^[789][0-9]{9}$/).nil?
  end
  
  def registered?
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
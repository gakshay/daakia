class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :mobile, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  validates_presence_of  :mobile, :if => :mobile_required?
  validates_format_of    :mobile, :with => /(^0?[789][0-9]{9}$)|(^\+?91[789][0-9]{9}$)/i, :allow_blank => true 
  validates_uniqueness_of :mobile, :allow_blank => true
  validates_numericality_of :mobile, :only_integer => true, :allow_nil  => true
  
  before_destroy :raise_if_last
  after_create { |admin| admin.send_reset_password_instructions }

  def password_required?
    new_record? ? false : super
  end
  
  protected 
  def mobile_required?
    true
  end
  
  def raise_if_last
    if AdminUser.count < 2
      raise "Can't delete last admin user"
    end
  end
end

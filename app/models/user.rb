class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :mobile, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :unread_count
  # attr_accessible :title, :body
  
  validates_presence_of  :mobile, :if => :mobile_required?
  validates_format_of    :mobile, :with => /(^0?[789][0-9]{9}$)|(^91[789][0-9]{9}$)/i, :allow_blank => true 
  validates_uniqueness_of :mobile, :allow_blank => true
  validates_numericality_of :mobile, :only_integer => true, :allow_nil  => true

  validates_format_of :password, :with => /(^[0-9]{4,6}$)/i, :allow_blank => true, :message => "Password: Only 4-6 Numbers Allowed"

  before_create :filter_mobile_number, :create_email_for_user

  def filter_mobile_number
    self.mobile = self.mobile[/\d{10}$/]  
  end

  def create_email_for_user
    self.email = "#{self.mobile}@edakia.in" unless self.mobile.blank?
  end
  
  def increment_unread_count
    User.increment_counter(:unread_count, self.id) 
  end
  
  def decrement_unread_count
    User.decrement_counter(:unread_count, self.id) if self.unread_count > 0
  end
  
  protected

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    mobile = conditions.delete(:mobile)
    where(conditions).where(["lower(mobile) = :value", { :value => mobile[/\d{10}$/]}]).first
  end

  def email_required?
   false
  end
  
  def mobile_required?
    true
  end
  
  
end

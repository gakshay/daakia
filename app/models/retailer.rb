class Retailer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :mobile, :password, :password_confirmation, :balance, :remember_me, :first_name, :last_name, :address, :city, :state, :age, :pincode
  # attr_accessible :title, :body
  validates_presence_of  :mobile, :if => :mobile_required?
  validates_format_of    :mobile, :with => /(^0?[789][0-9]{9}$)|(^\+?91[789][0-9]{9}$)/i, :allow_blank => true 
  validates_uniqueness_of :mobile, :allow_blank => true
  validates_numericality_of :mobile, :only_integer => true, :allow_nil  => true
  validates_numericality_of :age, :only_integer => true, :allow_nil  => true
  
  has_many :machines
  has_many :events, :through => :machines
  has_many :transactions#, :through => :events
  has_many :smses, :as => :service
  
  belongs_to :plan
  
  before_create :filter_mobile_number, :create_email_for_retailer
  
  def filter_mobile_number
    self.mobile = self.mobile[/\d{10}$/]  
  end

  def create_email_for_retailer
    self.email = "#{self.mobile}@edakia.in" if self.email.blank?
  end
  
  protected
  
  def mobile_required?
    true
  end
  
  def email_required?
   false
  end
  
end

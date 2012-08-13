class Document < ActiveRecord::Base
  attr_accessible :doc, :user_id
  has_attached_file :doc, :use_timestamp => true, :storage => :s3, :s3_credentials => S3_CREDENTIALS
  validates_attachment_presence :doc
  validates_attachment_content_type :doc, :content_type => [ 'image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'application/msword', 'application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ], :message => "File not supported"
  validates_attachment_size :doc, :less_than => 5.megabyte, :if => Proc.new { |imports| !imports.doc_file_name.blank? }
  
  
  belongs_to :user
  has_many :transactions
  
end

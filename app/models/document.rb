class Document < ActiveRecord::Base
  attr_accessible :doc, :user_id, :pages
  has_attached_file :doc, :use_timestamp => true, :storage => :s3, :s3_credentials => S3_CREDENTIALS
  validates_attachment_presence :doc
  validates_attachment_content_type :doc, :content_type => [ 'image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'text/html', 'text/plain', 'application/msword', 'application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ], :message => "File format not supported"
  validates_attachment_size :doc, :less_than => 5.megabyte, :message => "File must be less than 5MB", :if => Proc.new { |imports| !imports.doc_file_name.blank? }
  validates_presence_of :user_id
  
  belongs_to :user
  has_many :transactions
  
end

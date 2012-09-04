class Report < ActiveRecord::Base
  attr_accessible :message, :severity, :category
  
  def self.error(type,message)
    Report.create(:category => type, :message => message, :severity => "ERROR")
  end
  
  def self.debug(type,message)
    Report.create(:category => type, :message => message, :severity => "DEBUG")
  end
  
  def self.info(type,message)
    Report.create(:category => type, :message => message, :severity => "INFO")
  end
  
  def self.notice(type,message)
    Report.create(:category => type, :message => message, :severity => "NOTICE")
  end
  
  def self.warning(type,message)
    Report.create(:category => type, :message => message, :severity => "WARNING")
  end
  
  def self.critical(type,message)
    Report.create(:category => type, :message => message, :severity => "CRITICAL")
  end
end

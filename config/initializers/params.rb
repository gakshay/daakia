if Rails.env != "development"
  # set credentials from ENV hash
  MOBME_USERNAME = ENV['MOBME_USERNAME']
  MOBME_PASSWORD = ENV["MOBME_PASSWORD"]
  
else
  # get credentials from YML file
  MOBME_USERNAME = YAML.load_file(Rails.root.join("config/params.yml"))[Rails.env]["MOBME_USERNAME"]
  MOBME_PASSWORD = YAML.load_file(Rails.root.join("config/params.yml"))[Rails.env]["MOBME_PASSWORD"]
end
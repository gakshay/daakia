# initializers/edakia.rb

EDAKIA = YAML.load_file(Rails.root.join("config/host.yml"))[Rails.env]

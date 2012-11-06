desc "This task is called by the Heroku cron add-on"
task :wake_me_up => :environment do
   if Rails.env == "production"
     uri = "http://www.edakia.in"
   elsif Rails.env == "staging"
     uri = "http://staging.edakia.in"
   end
   Net::HTTP.get(uri)
     
end
# initializers/bitly.rb
if Rails.env != "development"
  # set credentials from ENV hash
  BITLY_USERNAME = ENV['BITLY_USERNAME']
  BITLY_APIKEY = ENV['BITLY_APIKEY']
else
  BITLY_USERNAME = "gakshay"
  BITLY_APIKEY = "R_b074bab72ab4f3247f6ca244e0cfbca7"
end

Bitly.use_api_version_3
Jmp = Bitly.new(BITLY_USERNAME, BITLY_APIKEY)
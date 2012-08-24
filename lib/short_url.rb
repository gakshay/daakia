# lib/short_url.rb

module ShortUrl
  HOST = EDAKIA['host']
  PATH = '/transactions/receive/'
  FULL_PATH = HOST + PATH
  PARAM1 = '?transaction[receiver_mobile]='
  PARAM2 = '&transaction[document_secret]='
  
  def self.shorten(mobile,secret)
    uri = URI.encode(ShortUrl::FULL_PATH + ShortUrl::PARAM1 + mobile + ShortUrl::PARAM2 + secret)
    url = Jmp.shorten(uri) # Jmp initialized in initializers/bitly.rb
    url.short_url
  end
end
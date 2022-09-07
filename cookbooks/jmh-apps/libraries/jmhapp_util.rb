
require 'net/http'

module JMHAPP_UTIL
  class << self
    def url_available?(url_check)

      require "net/http"
      url = URI.parse(url_check)
      req = Net::HTTP.new(url.host)
      begin
        res = req.request_head(url.path)
        if res.code == "200"
          return true
        else
          return false
        end
       rescue StandardError => boom
          return false
       end
   end
  end
end

require 'net/http'

module Guard
  class Passenger
    module Toucher
      class << self

        # try recieve header from given url (e.g. http://localhost:3000/) and return false if response status is 500
        def touch(host, port, path)
          begin
            response = nil;
            Net::HTTP.start(host, port) do |http|
              response = http.head(path)
            end
            (response['status'].to_s =~ /5[\d]{2}/).nil?
          rescue
            false
          end
        end
      end
    end
  end
end

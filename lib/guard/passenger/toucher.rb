require 'net/http'

module Guard
  class Passenger
    module Toucher
      class << self
        def touch(host, port, path)
          begin
            response = nil;
            Net::HTTP.start(host, port) do |http|
              response = http.head(path)
            end

            response['status'].to_i != 500
          rescue
            false
          end
        end
      end
    end
  end
end

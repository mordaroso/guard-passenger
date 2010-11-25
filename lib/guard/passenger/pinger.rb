require 'net/http'

module Guard
  class Passenger
    module Pinger
      class << self
        
        # try to ping given url (e.g. http://localhost:3000/) and display a message to inform of the result
        # failure == response status is 5xx
        # otherwise, it's a success
        def ping(host, port, path = '/')
          path = "/#{path}" unless path.match(/^\//)
          ping_in_thread = Thread.start {
            begin
              response = Net::HTTP.start(host, port) do |http|
                http.head(path)
              end
              if response =~ Net::HTTPServerError
                Notifier.notify "Passenger is not running!", :title => "Passenger", :image => :failed
              else
                Notifier.notify "Passenger is running.", :title => "Passenger", :image => :success
              end
            rescue
              # do nothing
            end
          }
        end
        
      end
    end
  end
end
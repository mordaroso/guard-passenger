module Guard
  class Passenger
    module Runner
      class << self
        
        def restart_passenger
           succeed = system("touch tmp/restart.txt")
           if succeed
             UI.info "Passenger successfully restarted."
           else
             UI.error "Passenger failed to restart!"
           end
           succeed
        end
        
        def start_passenger(port, environment)
          if passenger_standalone_installed?
            succeed = system("passenger start -p #{port} -d -e #{environment}")
            if succeed
              UI.info "Passenger standalone (port #{port}) started."
            else
              UI.error "Passenger standalone (port #{port}) failed to start!"
            end
            succeed
          else
            UI.error "Passenger standalone is not installed. You need at least Passenger version >= 3.0.0.\nPlease run 'gem install passenger' or add it to your Gemfile."
            false
          end
        end
        
        def stop_passenger(port)
          succeed = system("passenger stop -p #{port}")
          if succeed
            UI.info "Passenger standalone (port #{port}) stopped."
          else
            UI.error "Passenger standalone (port #{port}) failed to stop!"
          end
          succeed
        end
        
        def passenger_standalone_installed?
          begin
            gem "passenger", ">=3.0.0"
          rescue Gem::LoadError
            return false
          end
          true
        end
        
      end
    end
  end
end
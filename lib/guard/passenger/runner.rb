module Guard
  class Passenger
    module Runner
      class << self

        def restart_passenger
          result = system 'touch tmp/restart.txt'
          if result
            UI.info 'Successfully restarted passenger'
          else
            UI.error 'Restarting passenger failed'
          end

          result
        end

        def start_passenger(port, environment)
          if passenger_standalone_installed?
            result = system "passenger start -p #{port} -d -e #{environment}"
            if result
              UI.info "Passenger standalone startet at port #{port}"
            else
              UI.error "Passenger standalone failed to start at port #{port}"
            end
            result
          else
            UI.error "Passenger standalone is not installed. You need at least passenger version >= 3.0.0.\nPlease run 'gem install passenger' or add it to your Gemfile."
            false
          end
        end

        def stop_passenger
          result = system 'passenger stop'
          if result
            UI.info "Passenger standalone stopped"
          end
          true
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

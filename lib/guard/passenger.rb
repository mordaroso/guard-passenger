require 'guard'
require 'guard/guard'

module Guard
  class Passenger < Guard


    # ================
    # = Guard method =
    # ================

    def initialize(watchers = [], options = {})
      super
      @standalone = options[:standalone].nil? ? false : options[:standalone]
      @port = options[:port].nil? ? 3000 : options[:port]
    end

    # Call once when guard starts
    def start
      UI.info "Guard::Passenger is guarding your changes!"
      if standalone?
        start_passenger
      else
        true
      end
    end

    # Call with Ctrl-C signal (when Guard quit)
    def stop
      if standalone?
        stop_passenger
      else
        true
      end
    end

    # Call with Ctrl-Z signal
    def reload
      restart_passenger
    end

    # Call with Ctrl-/ signal
    def run_all
      true
    end

    # Call on file(s) modifications
    def run_on_change(paths)
      restart_passenger
    end

    def standalone?
      @standalone
    end

    def port
      @port
    end

    private
      def restart_passenger
        result = system 'touch tmp/restart.txt'
        if result
          UI.info 'Successfully restarted passenger'
        else
          UI.info 'Restarting passenger failed'
        end

        result
      end

      def start_passenger
        result = system "passenger start -p #{port} -d"
        if result
          UI.info "Passenger standalone startet at port #{port}"
        else
          UI.info "Passenger standalone failed to start at port #{port}"
        end
        result
      end

      def stop_passenger
        result = system 'passenger stop'
        if result
          UI.info "Passenger standalone stopeed"
        end
        true
      end

  end
end

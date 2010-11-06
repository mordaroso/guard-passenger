require 'guard'
require 'guard/guard'
require 'rubygems'

module Guard
  class Passenger < Guard

    autoload :Runner, 'guard/passenger/runner'

    attr_reader :port, :env

    def standalone?
      @standalone
    end

    # ================
    # = Guard method =
    # ================

    def initialize(watchers = [], options = {})
      super
      @standalone = options[:standalone].nil? ? false : options[:standalone]
      @port = options[:port].nil? ? 3000 : options[:port]
      @env = options[:env].nil? ? 'development' : options[:env]
    end

    # Call once when guard starts
    def start
      UI.info "Guard::Passenger is guarding your changes!"
      if standalone?
        Runner.start_passenger(port, env)
      else
        true
      end
    end

    # Call with Ctrl-C signal (when Guard quit)
    def stop
      if standalone?
        Runner.stop_passenger(port)
      else
        true
      end
    end

    # Call with Ctrl-Z signal
    def reload
      Runner.restart_passenger
    end

    # Call with Ctrl-/ signal
    def run_all
      true
    end

    # Call on file(s) modifications
    def run_on_change(paths)
      Runner.restart_passenger
    end
  end
end

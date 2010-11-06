require 'guard'
require 'guard/guard'
require 'rubygems'

module Guard
  class Passenger < Guard

    autoload :Runner, 'guard/passenger/runner'
    autoload :Toucher, 'guard/passenger/toucher'

    attr_reader :port, :env, :touch

    def standalone?
      @standalone
    end

    # ================
    # = Guard method =
    # ================

    def initialize(watchers = [], options = {})
      super
      @standalone = options[:standalone].nil? ? true : options[:standalone]
      @port = options[:port].nil? ? 3000 : options[:port]
      @env = options[:env].nil? ? 'development' : options[:env]
      @touch = options[:touch].nil? ? '/' : options[:touch]
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
      restart_and_touch
    end

    # Call with Ctrl-/ signal
    def run_all
      true
    end

    # Call on file(s) modifications
    def run_on_change(paths)
      restart_and_touch
    end

    private
      def restart_and_touch
        if Runner.restart_passenger & touch_url
          UI.info 'Successfully restarted passenger'
          true
        else
          UI.error 'Restarting passenger failed'
          false
        end
      end

      def touch_url
        if touch
          Toucher.touch('localhost', port, touch)
        else
          true
        end
      end
  end
end

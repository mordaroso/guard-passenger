require 'guard'
require 'guard/guard'

module Guard
  class Passenger < Guard

    # ================
    # = Guard method =
    # ================

    # Call once when guard starts
    def start
      true
    end

    # Call with Ctrl-C signal (when Guard quit)
    def stop
      true
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

    private
    def restart_passenger
      system 'touch tmp/restart.txt'
    end

  end
end

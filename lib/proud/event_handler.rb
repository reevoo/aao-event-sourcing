module Proud
  class EventHandler
    def handle(event)
      fail NotImplementedError
    end

    def stop
      # Do nothing
    end
  end
end

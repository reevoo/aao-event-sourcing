module Proud
  module StreamEngineGroup
    @workers = []

    def initialize
      @stop_flag = ServerEngine::BlockingFlag.new
    end

    def run
      Proud.streams.each(&:run)

      until @stop_flag.wait_for_set(Proud::CONFIG[:heartbeat])
        Proud.logger.debug('Heartbeat')
      end
    end

    def stop
      Proud.logger.info('Shutting down streams')
      Proud.streams.each(&:stop)
      @stop_flag.set!
      exit
    end

  end
end

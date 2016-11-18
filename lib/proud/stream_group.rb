module Proud
  class StreamGroup
    @workers = []

    def initialize(streams)
      @streams = streams
      @stop_flag = ServerEngine::BlockingFlag.new
    end

    def run
      @streams.each do |stream|
        stream.run
      end

      until @stop_flag.wait_for_set(Proud::CONFIG[:heartbeat])
        Proud.logger.debug('Heartbeat')
      end
    end

    def stop
      Proud.logger.info('Shutting down streams')
      @streams.each do |stream|
        stream.stop
      end
      @stop_flag.set!
    end

  end
end

module Proud
  class Stream < EventHandler

    def self.from(source)
      new(source)
    end

    def initialize(source)
      @source = source
      @event_handlers = []
      Proud.register_stream(self)
    end

    def trigger(event_handler, &transformer)
      @event_handlers << (assure_event_handler(event_handler) || SimpleListener.new(event_handler, &transformer))
      self
    end

    def transform(event_handler = nil, &transformer)
      @event_handlers << (assure_event_handler(event_handler) || SimpleTransformer.new(event_handler || transformer))
      self
    end

    def to(sink)
      @event_handlers << sink
      self
    end

    def handle(event)
      @event_handlers.reduce(event) do |intermediate_event, event_handler|
        event_handler.handle(intermediate_event)
      end
    end

    def run
      @thread = Thread.new do
        Proud.logger.info("Starting #{self}")
        @source.each_event { |event| handle(event) }
      end
    end

    def stop
      @source.stop
      @event_handlers.each(&:stop)
      @thread.exit
    end

    def to_s
      "Stream from #{@source}"
    end

    private

    def assure_event_handler(event_handler)
      event_handler if event_handler && event_handler.respond_to?(:handle)
    end
  end
end

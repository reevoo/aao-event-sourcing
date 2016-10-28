module Proud
  class Stream
    class SourceNotSupported < Proud::Error; end

    def self.from(source)
      new(source)
    end

    def initialize(source)
      fail SourceNotSupported, 'Source has to respond to #each_message' unless source.respond_to?(:each_message)
      @listeners = []
      @transformers = []
      source.each_message { |message| trigger_listeners(Message.from(message)) }
    end

    def trigger(callable, &block)
      @listeners << Listener.new(callable, transformers: listener_transformers(block))
      self
    end

    def transform(transformer = nil, &block)
      @transformers << transformer || block
      self
    end

    def to(raw_sink, options = {}, &block)
      @listeners << Sink.from(raw_sink, transformers: listener_transformers(block), options: options)
      self
    end

    private

    def trigger_listeners(message)
      @listeners.each { |listener| listener.trigger(message) }
    end

    def listener_transformers(block)
      @transformers.clone.tap do |trs|
        trs << block if block
      end
    end
  end
end

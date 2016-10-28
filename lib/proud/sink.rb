module Proud
  class Sink < Listener
    class NotSupported < Proud::Error; end

    def self.from(raw_sink, transformers: [], options: {})
      fail NotSupported unless defined? Kafka::AsyncProducer && raw_sink.is_a?(Kafka::AsyncProducer)

      callable = ->(message) do
        producer_options = {
          key:            message.meta[:key],
          topic:          message.meta[:topic],
          partition:      message.meta[:partition],
          partition_key:  message.meta[:partition_key],
        }.merge(options)

        raw_sink.produce(message.payload, producer_options)
      end

      new(callable, transformers: transformers)
    end

  end
end

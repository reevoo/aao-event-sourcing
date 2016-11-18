module Proud
  module Connectors
    class KafkaSink < Sink
      DEFAULT_OPTIONS = {
        delivery_interval: 5,
      }.freeze

      def initialize(kafka_instance, options = {})
        @producer = kafka_instance.async_producer(DEFAULT_OPTIONS.merge(options))
      end

      def handle(event)
        kafka_options = { topic: event.type }.merge(event.meta.fetch(:kafka, {}))
        @producer.produce(event.payload, kafka_options)
      end
    end
  end
end

module Proud
  module Connectors
    class KafkaSource < Proud::Source
      def initialize(kafka_instance, event_type:, **options)
        @event_type = event_type
        @consumer = kafka_instance.consumer(group_id: "#{event_type}-group")
        @consumer.subscribe(event_type, options)
      end

      def each_event(&block)
        @consumer.each_message do |message|
          event_attribs = JSON.parse(message.value, symbolize_names: true).slice(:id, :payload, :timestamp)
          event_attribs.merge!(
            type: event_type,
            meta: {
              kafka: {
                key:        message.key,
                topic:      message.topic,
                partition:  message.partition,
                offset:     message.offset,
              }
            }
          )

          yield Event.new(event_attribs)
        end
      end

    end
  end
end

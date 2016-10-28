module Proud
  class Message
    class FormatNotSupported < Proud::Error; end

    attr_reader :payload, :meta

    def self.from(raw_message)
      fail FormatNotSupported unless defined? Kafka::FetchedMessage && raw_message.is_a?(Kafka::FetchedMessage)
      new(raw_message.value,
        key:        raw_message.key,
        topic:      raw_message.topic,
        partition:  raw_message.partition,
        offset:     raw_message.offset,
      )
    end

    def initialize(payload, meta = {})
      @payload = payload.freeze
      @meta = meta.freeze
    end

    def merge(attrs = {})
      new_payload = attrs.key?(:payload) ? attrs[:payload] : payload
      new_meta = meta.merge(attrs.reject { |key| key == :payload })
      Message.new(new_payload, new_meta)
    end
  end
end


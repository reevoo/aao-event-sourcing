require 'spec_helper'
require 'proud'

describe 'Integration spec' do
  describe 'sample flow' do
    class FakeConsumer
      def initialize
        @listeners = []
      end

      def each_message(&block)
        @listeners << block
      end

      def send_message(message)
        @listeners.each { |listener| listener.call(message) }
      end
    end

    let!(:consumer) { FakeConsumer.new }
    let!(:message) do
      Kafka::FetchedMessage.new(
        value: 'hello',
        key: 'key1',
        topic: 'topic1',
        partition: 2,
        offset: 3,
      )
    end
    let!(:callable) { ->(message) {} }
    let!(:transformer) { ->(message) { message.merge(payload: message.payload + ' all', key: 'key2') } }
    let!(:producer) { instance_double(Kafka::AsyncProducer) }

    let!(:stream) do
      Proud::Stream.from(consumer)
        .trigger(callable) do |message|
          { data: message.payload, key: message.meta[:key] }
        end
        .transform(transformer)
        .to(producer, topic: 'greetings')
    end

    it 'works' do
      expect(callable).to receive(:call).with({ data: 'hello', key: 'key1' })
      expect(producer).to receive(:produce).with('hello all',
        key: 'key2',
        topic: 'greetings',
        partition: 2,
        partition_key: nil,
      )

      consumer.send_message(message)
    end
  end
end

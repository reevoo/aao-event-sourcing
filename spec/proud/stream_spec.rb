require 'spec_helper'
require 'proud'

describe Proud::Stream do
  describe 'sample setup' do
    let!(:source) { nil }
    let!(:event) do
      Proud::Event.new(
        type: 'type1',
        payload: { foo: 'hello' },
        meta: { key: 'key1' },
      )
    end
    let!(:callable) { ->(event) {} }
    let!(:transformer) do
      ->(event) do
        Proud::Event.new(
          type: 'type2',
          payload: event.payload.merge(bar: 123),
        )
      end
    end
    let!(:sink) { instance_double(Proud::Sink) }

    let!(:stream) do
      Proud::Stream.from(source)
        .trigger(callable) do |event|
          { data: event.payload, key: event.meta[:key] }
        end
        .transform(transformer)
        .to(sink)
    end

    it 'works' do
      expect(callable).to receive(:call).with(data: { foo: 'hello' }, key: 'key1')
      expect(sink).to receive(:handle).with(Proud::Event)
      # TODO: check content of event

      stream.handle(event)
    end


    context 'with source' do
      class FakeSource < Proud::Source
        def initialize
          @blocks = []
        end

        def each_event(&block)
          @blocks << block
        end

        def send_event(event)
          @blocks.each { |blocks| blocks.call(event) }
        end
      end

      let!(:source) { FakeSource.new }

      it 'works' do
        expect(callable).to receive(:call).with(data: { foo: 'hello' }, key: 'key1')
        expect(sink).to receive(:handle).with(Proud::Event)
        # TODO: check content of event

        stream.run
        source.send_event(event)
      end
    end
  end
end

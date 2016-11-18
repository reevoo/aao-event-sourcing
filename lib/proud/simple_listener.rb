module Proud
  class SimpleListener < EventHandler

    def initialize(callable, &block)
      @callable = callable
      @transformer = block
    end

    def handle(event)
      @callable.call(transform_event(event))
      event
    end


    private

    def transform_event(event)
      if @transformer && @transformer.respond_to?(:call)
        @transformer.call(event)
      else
        event
      end
    end
  end
end

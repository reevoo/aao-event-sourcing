module Proud
  class SimpleTransformer < EventHandler

    def initialize(callable)
      @callable = callable
    end

    def handle(event)
      @callable.call(event)
    end
  end
end

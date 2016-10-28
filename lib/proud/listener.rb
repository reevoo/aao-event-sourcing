module Proud
  class Listener

    def initialize(callable, transformers: [])
      @callable = callable
      @transformers = transformers
    end

    def trigger(message)
      @callable.call(transform_message(message))
    end


    private

    def transform_message(message)
      @transformers.reduce(message) do |transformed_message, transformer|
        transformer.call(transformed_message)
      end
    end
  end
end

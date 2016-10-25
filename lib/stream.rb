class Stream
  def self.from(source)
    new(source)
  end

  def initialize(source)
    @source = source
  end

  def trigger(callable)
  end

  def to(sink)
  end
end

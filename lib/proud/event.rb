require 'uuidtools'

module Proud
  class Event
    attr_reader :type, :id, :timestamp, :payload, :meta

    def initialize(type:, id: nil, timestamp: nil, payload: {}, meta: {})
      @type = type.freeze
      @id = id || UUIDTools::UUID.random_create
      @timestamp = timestamp || DateTime.now
      @payload = payload.freeze
      @meta = meta.freeze
    end
  end
end

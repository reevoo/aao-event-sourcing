require 'uuidtools'

module Proud
  class Event
    attr_reader :type, :id, :timestamp, :payload, :meta, :parent

    def initialize(type:, id: nil, timestamp: nil, parent: nil, payload: {}, meta: {})
      @type = type.freeze
      @id = id || UUIDTools::UUID.random_create
      @timestamp = timestamp || DateTime.now
      @parent = { id: parent.id, type: parent.type } if parent
      @payload = payload.freeze
      @meta = meta.freeze
    end
  end
end

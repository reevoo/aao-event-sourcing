require "kafka"

module ConversationService
  KAFKA = Kafka.new(seed_brokers: ["localhost:2181"])
end

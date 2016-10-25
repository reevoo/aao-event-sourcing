require "conversation_service/kafka"
require "stream"

module ConversationService
  # whole flow:
  # question_submitted
  # question_accepted (question_rejected)
  # answer_submitted
  # answer_accepted (answer_rejected)

  class Flow
    def self.init
      producer = KAFKA.async_producer(delivery_interval: 5)

      Stream.from(build_consumer(:question_accepted))
        .trigger(EmailService.method(:request_answer)) do |event|
          {
            question: event.payload,
            recipient: QuestionRecipientFinder,
          }
        end
        .trigger(ConversationStore.method(:answer_requested))
        .to(producer, topic: 'conversation.answer_requested')

      Stream.from(build_consumer(:answer_accepted)).trigger(ConversationStore.method(:create_answer))
    end


    def self.rebuild_store
      Stream.from(build_consumer(:question_accepted, start_from_beginning: true))
        .trigger(ConversationStore.method(:question_accepted))

      Stream.from(build_consumer(:answer_requested, start_from_beginning: true))
        .trigger(ConversationStore.method(:answer_requested))

      Stream.from(build_consumer(:answer_accepted, start_from_beginning: true))
        .trigger(ConversationStore.method(:answer_accepted))
    end


    def self.build_consumer(topic_base_name, subscribe_options = {})
      KAFKA.consumer(group_id: "conversation_service-#{topic_base_name}").tap |c|
        c.subscribe("conversation.#{topic_base_name}", subscribe_options)
      end
    end
  end

end

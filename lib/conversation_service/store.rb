module ConversationService
  class Store
    def self.create_answer(question:, answer:)
      ConversationService.logger.info "Answer #{answer} for question #{question}"
    end
  end
end

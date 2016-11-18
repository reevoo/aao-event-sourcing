module ConversationService
  class Mailer
    def self.request_answer(question:, recipient:)
      ConversationService.logger.info "Emailing #{recipient} asking about #{question}"
    end
  end
end

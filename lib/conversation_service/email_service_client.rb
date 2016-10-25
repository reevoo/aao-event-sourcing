module ConversationService
  class EmailServiceClient
    def self.request_answer(question:, recipient:)
      puts "Emailing #{recipient.email} asking about #{question.title}"
    end
  end
end

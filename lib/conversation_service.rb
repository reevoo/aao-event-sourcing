require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

$LOAD_PATH << File.expand_path('../', __FILE__)

ENV['RACK_ENV'] ||= 'development'

if %w(development test).include? ENV['RACK_ENV']
  require 'pry'
  # require 'dotenv'
  # Dotenv.load(ENV['RACK_ENV'] == 'development' ? '.env' : ".env.#{ENV['RACK_ENV']}")
end


require 'active_support'
require 'active_support/core_ext/array'
require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'

module ConversationService
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

require 'conversation_service/mailer'
require 'conversation_service/store'
require 'conversation_service/question_recipient_finder'

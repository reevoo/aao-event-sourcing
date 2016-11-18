module Proud
  class Error < StandardError; end

  extend self

  CONFIG = {
    heartbeat: 10,
    log: STDOUT,
    pid_path: 'proud.pid'
  }

  def logger
    @logger ||= ServerEngine::DaemonLogger.new(CONFIG[:log])
  end

  def register_stream(stream)
    streams << stream
  end

  def streams
    @streams ||= []
  end

  def run
    @se = ServerEngine.create(nil, StreamGroup.new(streams), {
      daemonize: true,
      log: logger,
      pid_path: CONFIG[:pid_path],
    })
    @se.run
  end
end

require 'proud/event'
require 'proud/event_handler'
require 'proud/simple_listener'
require 'proud/simple_transformer'
require 'proud/source'
require 'proud/sink'
require 'proud/stream'
require 'proud/stream_group'
require 'proud/connectors/kafka_source'
require 'proud/connectors/kafka_sink'

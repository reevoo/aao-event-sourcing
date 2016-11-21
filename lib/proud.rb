module Proud
  class Error < StandardError; end

  extend self

  CONFIG = {
    heartbeat: 5,
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
    Thread.abort_on_exception = true
    @se = ServerEngine.create(nil, StreamEngineGroup, {
      daemonize: false,
      log: CONFIG[:log],
      # pid_path: CONFIG[:pid_path],
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
require 'proud/stream_engine_group'
require 'proud/connectors/kafka_source'
require 'proud/connectors/kafka_sink'

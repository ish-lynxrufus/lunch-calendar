require 'logger'

module Batch::Log
  LOG_FILE_PATH = 'log/batch.log'.freeze

  def logger
    @console ||= ActiveSupport::Logger.new(STDOUT)
    @logger ||= ActiveSupport::Logger.new(LOG_FILE_PATH).tap do |config|
      config.formatter = ::Logger::Formatter.new
      config.extend ActiveSupport::Logger.broadcast(@console)
    end
  end
end
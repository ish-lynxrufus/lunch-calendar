module Batch::LineBot
  extend Batch::Log

  def self.push
    text = Calendar.new.event_summaries.join("\n")
    response = ::LineBot.new.push(text)

    logger.info("#{response.header}\n#{response.body}\n[text]\n#{text}")
  end
end
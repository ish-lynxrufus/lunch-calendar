class LineBot
  def initialize
    @client = bot_client
  end

  def reply(text, token)
    @client.reply_message(token, message(text))
  end

  def push(text)
    @client.multicast(line_ids, message(text))
  end

  def user_name(id)
    response = @client.get_profile(id)
    case response
    when Net::HTTPSuccess
      contact = JSON.parse(response.body)
      contact['displayName']
    end
  end

  def parse_events(body)
    @client.parse_events_from(body)
  end

  def validate_signature(body, signature)
    @client.validate_signature(body, signature)
  end

  private

  def bot_client
    Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def message(text)
    {
      type: 'text',
      text: text
    }
  end

  def line_ids
    LineFriend::line_ids
  end
end

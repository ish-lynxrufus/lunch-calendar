class LineEvent
  def initialize(event)
    @event = event
  end

  def message
    @event.message['text']
  end

  def user_id
    @event['source']['userId']
  end

  def reply_token
    @event['replyToken']
  end

  def text_message?
    @event.instance_of?(Line::Bot::Event::Message) && @event.type == 'text'
  end

  def follow?
    @event.instance_of?(Line::Bot::Event::Follow)
  end
end

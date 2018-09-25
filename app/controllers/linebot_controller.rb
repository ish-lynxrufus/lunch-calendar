class LinebotController < ApplicationController
  require 'line/bot'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          reply_message(event['replyToken'], event.message['text'])
        end
      when Line::Bot::Event::Follow
        user_id = event['source']['userId']
        friend = LineFriend.create(line_id: user_id, display_name: user_name(user_id))
        message = "#{friend.display_name}さん、友達登録ありがとうございます！！"
        reply_message(event['replyToken'], message)
      end
    end

    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end

  def user_name(id)
    response = client.get_profile(id)
    case response
    when Net::HTTPSuccess
      contact = JSON.parse(response.body)
      contact['displayName']
    end
  end

  def reply_message(token, message)
    message = {
      type: 'text',
      text: message
    }
    client.reply_message(token, message)
  end
end

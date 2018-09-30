class LineBotController < ApplicationController
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def callback
    line_bot = LineBot.new

    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head(:bad_request) unless line_bot.validate_signature(body, signature)

    line_bot.parse_events(body).each do |e|
      event = LineEvent.new(e)

      # メッセージの受信
      if event.text_message?
        next line_bot.reply(event.message, event.reply_token)
      end

      # 友達登録、ブロック解除
      if event.follow?
        friend = LineFriend.create(
          line_id: event.user_id,
          display_name: line_bot.user_name(event.user_id)
        )
        message = "#{friend.display_name}さん、友達登録ありがとうございます！！"
        next line_bot.reply(message, event.reply_token)
      end
    end

    head :ok
  end
end

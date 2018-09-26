class LineFriend < ApplicationRecord
  class << self
    def add(id, name)
      create(
        line_id: event.user_id,
        display_name: line_bot.user_name(event.user_id)
      )
    end

    def line_ids
      pluck(:line_id).uniq
    end
  end
end

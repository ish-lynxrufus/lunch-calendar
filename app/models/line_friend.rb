class LineFriend < ApplicationRecord
  def self.line_ids
    pluck(:line_id).uniq
  end
end

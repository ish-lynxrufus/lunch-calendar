namespace :line_bot do
  task push: :environment do
    Batch::LineBot.push
  end
end
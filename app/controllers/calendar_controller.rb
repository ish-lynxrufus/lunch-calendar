class CalendarController < ApplicationController
  CALENDAR_ID = 'ddge7mv6947hmcfcovq56a1fu8@group.calendar.google.com'.freeze

  def events
    summaries = Calendar.new.events.items.map(&:summary)
    render json: summaries
  end
end

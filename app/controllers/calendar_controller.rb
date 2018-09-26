class CalendarController < ApplicationController
  CALENDAR_ID = 'ddge7mv6947hmcfcovq56a1fu8@group.calendar.google.com'.freeze

  def events
    summaries = Calendar.new.event_summaries
    render json: summaries
  end
end

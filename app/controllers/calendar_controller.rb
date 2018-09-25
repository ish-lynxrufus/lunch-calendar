class CalendarController < ApplicationController
  CALENDAR_ID = 'ddge7mv6947hmcfcovq56a1fu8@group.calendar.google.com'.freeze

  def events
    events = Calendar.new.events
    items = events.items.map{ |item| { title: item.summary, date: item.start.date } }
    render json: items
  end
end

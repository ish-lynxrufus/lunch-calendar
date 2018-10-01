class Calendar
  APPLICATION_NAME = ENV['GOOGLE_CALENDAR_APPLICATION_NAME'].freeze
  CALENDAR_ID = ENV['GOOGLE_CALENDAR_ID'].freeze

  def initialize
    @service = calendar_service
    @calendar_id = CALENDAR_ID
  end

  def events
    @service.list_events(
      @calendar_id,
      time_min: 30.minute.since.iso8601,
      time_max: 90.minute.since.iso8601,
    )
  end

  def event_summaries
    events.items.map(&:summary)
  end

  private

  def calendar_service
    Google::Apis::CalendarV3::CalendarService.new.tap do |service|
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize
    end
  end

  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
    )
    authorizer.fetch_access_token!
    authorizer
  end
end

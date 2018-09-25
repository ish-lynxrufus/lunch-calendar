class CalendarController < ApplicationController
  CALENDAR_ID = 'ddge7mv6947hmcfcovq56a1fu8@group.calendar.google.com'.freeze

  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    time_min = 30.minute.since.iso8601
    time_max = 90.minute.since.iso8601

    events = service.list_events(CALENDAR_ID, time_min: time_min, time_max: time_max)
    items = events.items.map{ |item| { title: item.summary, date: item.start.date } }

    render json: items
  rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  end

  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to calendar_events_url
  end

  private

  def client_options
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri: calendar_callback_url
    }
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/calendar' do
    get '/events/', to: 'calendar#events', as: 'calendar_events'
  end

  scope '/linebot' do
    post '/callback/', to: 'line_bot#callback', as: 'line_bot_callback'
    get '/push/', to: 'line_bot#push', as: 'line_bot_push'
  end
end

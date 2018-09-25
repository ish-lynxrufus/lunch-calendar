Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/calendar' do
    get '/events/', to: 'calendar#events', as: 'calendar_events'
  end
end

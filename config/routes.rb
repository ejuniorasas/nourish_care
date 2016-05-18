Rails.application.routes.draw do
  apipie
  scope '/api' do
    resources :appointments
    resources :schedules
  end
end

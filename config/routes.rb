Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # Defines the root path route ("/")
  # root "posts#index"

  get "up" => "rails/health#show", as: :rails_health_check
  resources :games, only: [:create]

  post '/join_game', to: 'games#join_game'
  post '/change_position', to: 'games#change_position'
  get '/check_game_status', to: 'games#check_game_status'
  get '/check_board_pieces', to: 'games#check_board_pieces'
end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users
  resources :users
  resource :account, :controller => 'users'
  resources :teams
  resources :divisions

  root to: "bets#scoreboard"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  get ':controller(/:action(/:id))(.:format)'
end

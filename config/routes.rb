Rails.application.routes.draw do
  root "events#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users do
    collection do
      get "login" => "users#login", as: :login
      get "logout" => "users#logout", as: :logout
      get "info" => "users#info"
    end
  end

  resources :events

  get  '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'

end

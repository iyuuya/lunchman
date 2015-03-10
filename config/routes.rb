Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
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

  resources :events do
    post "participate" => "events#participate", as: :participate
    post "cancel_participate" => "events#cancel_participate", as: :cancel_participate
  end

  resources :suggestions, only: :create

  post "suggest" => "events#suggest"

  get  '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end

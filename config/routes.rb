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

  resources :events do
    post "participate" => "events#participate", as: :participate
    post "cancel_participate" => "events#cancel_participate", as: :cancel_participate
    post "post_message" => "events#post_message", as: :post_message
  end

  resources :suggestions

  post "suggest" => "events#suggest"
  get "suggest_list" => "suggestions#show_list"

  get  '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end

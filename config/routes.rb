Rails.application.routes.draw do

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

end

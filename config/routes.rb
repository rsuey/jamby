require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :group_sessions do
    member do
      get :book
      get :cancel_booking
      post :ready
      put :ping
    end
  end

  get 'signin' => 'signins#new'
  delete 'logout' => 'signins#destroy', as: :signout
  get 'signup' => 'signups#new'

  resources :signups, only: :create
  resources :signins, only: :create
  get '/auth/google_oauth2/callback' => 'events#create'

  resources :password_resets, only: [:new, :create]
  resources :passwords, only: [:new, :create]

  resource :account, only: [:update, :destroy] do
    get :dashboard
    get :edit
  end

  resources :payout_accounts, except: :index
  resources :payment_methods, except: :index
  resources :payments, only: :create do
    get :confirm, on: :member
  end

  post 'messenger/auth'

  root 'group_sessions#index'
end

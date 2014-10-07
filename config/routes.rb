Rails.application.routes.draw do
  resources :group_sessions do
    member do
      get :book
      get :cancel_booking
      post :ready
    end
  end

  get 'signin' => 'signins#new'
  delete 'logout' => 'signins#destroy', as: :signout
  get 'signup' => 'signups#new'

  resources :signups, only: :create
  resources :signins, only: :create

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

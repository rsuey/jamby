Rails.application.routes.draw do
  resources :group_sessions do
    get :book, on: :member
    post :ready, on: :member
  end

  get 'signin' => 'signins#new'
  delete 'logout' => 'signins#destroy', as: :signout
  get 'signup' => 'signups#new'

  resources :signups, only: :create
  resources :signins, only: :create

  resource :account, only: [:update, :destroy] do
    get :dashboard
    get :edit
  end

  resources :payment_methods, except: :index
  resources :payments, only: :create do
    get :confirm, on: :member
  end

  post 'messenger/auth'

  root 'group_sessions#index'
end

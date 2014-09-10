Rails.application.routes.draw do
  resources :group_sessions do
    get :book, on: :member
  end

  get 'signin' => 'sessions#new'
  get 'signup' => 'signups#new'

  resources :users, controller: :signups, only: :create

  root 'group_sessions#index'
end

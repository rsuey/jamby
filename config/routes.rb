Rails.application.routes.draw do
  resources :group_sessions do
    get :book, on: :member
  end

  get 'signup' => 'signups#new', as: :new_signup
  resources :users, controller: :signups, only: :create

  root 'group_sessions#index'
end

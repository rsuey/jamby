Rails.application.routes.draw do
  resources :group_sessions, only: [:new, :create]
  root 'group_sessions#index'
end

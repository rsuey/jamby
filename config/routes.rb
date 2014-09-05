Rails.application.routes.draw do
  resources :group_sessions, except: [:index, :destroy]
  root 'group_sessions#index'
end

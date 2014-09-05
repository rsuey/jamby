Rails.application.routes.draw do
  resources :group_sessions
  root 'group_sessions#index'
end

Rails.application.routes.draw do
  resources :group_sessions do
    get :book, on: :member
  end

  root 'group_sessions#index'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # users
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }, skip: [:passwords, :sessions, :registrations]
  devise_scope :user do
    resources :sessions, only: [:new, :destroy], controller: 'devise/sessions'
  end

  resources :pages, only: [:show], params: :name

  root to: 'pages#show', name: 'landing_page'
end

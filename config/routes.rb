Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # users
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }, skip: [:passwords, :sessions, :registrations]
  devise_scope :user do
    # resources :sessions, only: [:destroy], controller: 'devise/sessions'
    # get 'signin' => 'devise/sessions#new', :as => :new_user_session
    # post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'sessions/destroy_current' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :pages, only: [:show], params: :name

  root to: 'pages#show', name: 'landing_page'
end

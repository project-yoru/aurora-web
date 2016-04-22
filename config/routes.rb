Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # sidekiq monitor
  # TODO enable this after this issue being resolved: https://github.com/sinatra/sinatra/pull/1090

  # require 'sidekiq/web'
  # authenticate :user, lambda { |u| u.email == 'namiheike@gmail.com' } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # users
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }, skip: [:passwords, :sessions, :registrations]
  devise_scope :user do
    resources :sessions, as: :user_session, only: [:new], controller: 'devise/sessions'
    delete '/destroy' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :projects, only: [:show, :index, :new, :create] do
    resources :distributions, shallow: true do
      member do
        patch 'start_building'
        patch 'halt'
      end
    end
  end

  resources :pages, only: [:show], params: :name

  # api
  mount API::Base => '/api'

  root to: 'pages#show', name: 'landing_page'
end

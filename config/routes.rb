Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  resources :pages, only: [:show], params: :name

  root to: 'pages#show', name: 'landing_page'
end

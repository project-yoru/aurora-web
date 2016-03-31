Sidekiq.configure_server{ |config| config.redis = { url: Rails.application.secrets.redis[:url], namespace: 'aurora-web-sidekiq' } }
Sidekiq.configure_client{ |config| config.redis = { url: Rails.application.secrets.redis[:url], namespace: 'aurora-web-sidekiq' } }

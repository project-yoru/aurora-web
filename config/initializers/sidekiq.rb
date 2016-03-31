Sidekiq.configure_server{ |config| config.redis = { namespace: 'aurora-web-sidekiq', url: Rails.application.secrets.redis[:url] } }
Sidekiq.configure_client{ |config| config.redis = { namespace: 'aurora-web-sidekiq', url: Rails.application.secrets.redis[:url] } }

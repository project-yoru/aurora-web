$redis = Redis::Namespace.new :"aurora-web", redis: ( Redis.new Rails.application.secrets.redis )

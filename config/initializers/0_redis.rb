# namespaced in development

if Rails.env.development?
  $redis = Redis::Namespace.new :"aurora-web", redis: ( Redis.new Rails.application.secrets.redis )
else
  $redis = Redis.new Rails.application.secrets.redis
end

class BuildingQueue
  class << self
    def push distribution
      redis = Redis.new Rails.application.secrets.redis
      redis.lpush 'aurora_web_building_queue', distribution.to_global_id
    end

    def pop
      redis = Redis.new Rails.application.secrets.redis
      if distribution_global_id = redis.lpop('aurora_web_building_queue')
        GlobalID::Locator.locate distribution_global_id
      else
        nil
      end
    end
  end
end

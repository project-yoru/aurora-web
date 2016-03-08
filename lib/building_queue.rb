class BuildingQueue
  class << self
    def push distribution
      # TODO shouldn't create new redis connection every time
      redis = Redis.new Rails.application.secrets.redis
      redis.lpush 'aurora_web_building_queue', distribution.to_global_id
      if size == 1
        pop_and_build
      end
    end

    def pop
      redis = Redis.new Rails.application.secrets.redis
      if distribution_global_id = redis.lpop('aurora_web_building_queue')
        GlobalID::Locator.locate distribution_global_id
      else
        nil
      end
    end

    def size
      redis = Redis.new Rails.application.secrets.redis
      redis.llen 'aurora_web_building_queue'
    end

    def pop_and_build
      unless distribution = pop
        distribution.build
      end
    end
  end
end

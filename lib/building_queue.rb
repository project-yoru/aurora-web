# TODO what if distribution got deleted

class BuildingQueue
  class << self
    def push distribution
      $redis.lpush 'aurora_web_building_queue', distribution.to_global_id
    end

    def pop
      if distribution_global_id = $redis.lpop('aurora_web_building_queue')
        GlobalID::Locator.locate distribution_global_id
      else
        nil
      end
    end

    def size
      $redis.llen 'aurora_web_building_queue'
    end

    def pop_and_build
      if distribution = pop
        distribution.build!
      end
    end

    def clear
      $redis.del 'aurora_web_building_queue'
    end
  end
end

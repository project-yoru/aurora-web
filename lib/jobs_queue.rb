class JobsQueue
	SET_PREFIX = 'aurora_web_build_queue_'

	def initialize redis, name
		@redis = redis
    @name = SET_PREFIX + name.to_s
	end

	def push distribution
		@redis.zadd SET_NAME, Time.now.to_i, distribution.to_global_id
	end

	def pop
    if first_distribution_gid = @redis.zrange(SET_NAME, 0, 0).first
      @redis.zrem SET_NAME, first_distribution_gid
      GlobalID::Locator.locate first_distribution_gid
    else
      nil
    end
	end

	def remove! distribution
    # return true if found and removed
		distribution_global_id = distribution.to_global_id
		@redis.zrem(SET_NAME, distribution_global_id) == 1
	end

end

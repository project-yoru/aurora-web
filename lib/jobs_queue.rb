class JobsQueue
	SET_PREFIX = 'aurora_web_jobs_queue_'

	def initialize redis, name
		@redis = redis
    @name = SET_PREFIX + name.to_s
	end

	def push distribution
		@redis.zadd @name, Time.now.to_i, build_job(distribution)
	end

	def pop
    if poped_job = @redis.zrange(@name, 0, 0).first
      parsed_job = parse_job JSON.parse(poped_job)
      @redis.zrem @name, poped_job
      return parsed_job
    else
      nil
    end
	end

	def remove! distribution
    # return true if found and removed
		distribution_global_id = distribution.to_global_id
		@redis.zrem(@name, distribution_global_id) == 1
	end

  def size
    @redis.zcard @name
  end

  private

  def build_job distribution
    {
      distribution: {
        gid: distribution.to_global_id.go_s
      }
    }.to_json
  end

  def parse_job job_hash
    job_hash.symbolize_keys!
    job_hash[:distribution] = GlobalID::Locator.locate job_hash[:distribution][:gid]
    job_hash
  end

end

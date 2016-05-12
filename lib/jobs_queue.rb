class JobsQueue
	SET_PREFIX = 'aurora_web_jobs_queue_'

	def initialize redis, name
		@redis = redis
    @name = SET_PREFIX + name.to_s
	end

	def push distribution
    @redis.zadd @name, Time.now.to_i, ( job = build_new_job distribution ).to_json
    return job[:id]
	end

	def pop
    return nil unless popped_job = @redis.zrange(@name, 0, 0).first
    parsed_popped_job = parse_popping_job JSON.parse(popped_job)
    @redis.zrem @name, popped_job
    return parsed_popped_job
	end

  def remove! distribution
    # return true if found and removed
    @redis.zrem @name, ( build_existing_job distribution ).to_json
  end

  def size
    @redis.zcard @name
  end

  def clear!
    @redis.del @name
  end

  private

  def build_new_job distribution
    {
      id: SecureRandom.uuid,
      distribution_id: distribution.id
    }
  end

  def build_existing_job distribution
    {
      id: distribution.current_building_job_id,
      distribution_id: distribution.id
    }
  end

  def parse_popping_job popped_job
    distribution = Distribution.find popped_job['distribution_id']
    {
      id: popped_job['id'],
      project: distribution.project.as_json(only: [:id, :name, :git_repo_path]),
      distribution: distribution.as_json(only: [:id, :platform])
    }.deep_symbolize_keys
  end

end

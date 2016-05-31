class JobsQueue
  SET_PREFIX = 'aurora_web_jobs_queue_'

  def initialize redis, name
    @redis = redis
    @name = SET_PREFIX + name.to_s
  end

  def push type:, project: nil, online_preview: nil, distribution: nil
    # type:
    # - :config, with a project
    # - :build, with a distribution

    case type
    when :config
      @redis.zadd @name, Time.now.to_i, ( job = build_new_job :config, project: project ).to_json
    when :build_online_preview
      @redis.zadd @name, Time.now.to_i, ( job = build_new_job :build_online_preview, online_preview: online_preview ).to_json
    when :build
      @redis.zadd @name, Time.now.to_i, ( job = build_new_job :build, distribution: distribution ).to_json
    end

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
    @redis.zrem @name, ( build_existing_build_job distribution ).to_json
  end

  def size
    @redis.zcard @name
  end

  def clear!
    @redis.del @name
  end

  private

  def build_new_job type, project: nil, online_preview: nil, distribution: nil
    case type
    when :config
      {
        id: SecureRandom.uuid,
        type: :config,
        project_id: project.id
      }
    when :build_online_preview
      {
        id: SecureRandom.uuid,
        type: :build_online_preview,
        online_preview_id: online_preview.id
      }
    when :build
      {
        id: SecureRandom.uuid,
        type: :build,
        distribution_id: distribution.id
      }
    end
  end

  def build_existing_build_job distribution
    {
      id: distribution.current_building_job_id,
      type: :build,
      distribution_id: distribution.id
    }
  end

  def parse_popping_job popped_job
    case popped_job['type']
    when 'config'
      project = Project.find popped_job['project_id']
      return {
        id: popped_job['id'],
        type: :config,
        project: project.as_json(only: [:id, :name, :git_repo_path])
      }.deep_symbolize_keys
    when 'build_online_preview'
      online_preview = OnlinePreview.find popped_job['online_preview_id']
      return {
        id: popped_job['id'],
        type: :build_online_preview,
        project: online_preview.project.as_json(only: [:id, :name, :git_repo_path]),
        online_preview: online_preview.as_json(only: [:id])
      }.deep_symbolize_keys
    when 'build'
      distribution = Distribution.find popped_job['distribution_id']
      return {
        id: popped_job['id'],
        type: :build,
        project: distribution.project.as_json(only: [:id, :name, :git_repo_path]),
        distribution: distribution.as_json(only: [:id, :platform])
      }.deep_symbolize_keys
    end
  end

end

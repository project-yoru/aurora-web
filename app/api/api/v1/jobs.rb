module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json

      resource :jobs do
        desc 'pop first distribution from the build queue'
        delete 'to_build/pop' do
          job_hash = $jobs_queues[:to_build].pop
          job_hash[:distribution] = job_hash[:distribution].as_json(only: [:id, :source_type, :github_repo_path ])
          job_hash
        end
      end
    end
  end
end

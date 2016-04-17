module API
  module V1
    class BuildQueue < Grape::API
      version 'v1'
      format :json

      resource :build_queue do
        desc 'pop first distribution from the build queue'
        delete 'pop' do
          $build_queue.pop.as_json only: [:id, :source_type, :github_repo_path ]
        end
      end
    end
  end
end

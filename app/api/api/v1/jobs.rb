module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json

      resource :jobs do
        desc 'pop first distribution from the build queue'
        delete 'to_build/pop' do
          $jobs_queues[:to_build].pop
        end
      end
    end
  end
end

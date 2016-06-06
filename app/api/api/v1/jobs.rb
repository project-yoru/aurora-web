# TODO SECURITY auth request

module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json

      resource :jobs do
        desc 'pop first distribution from the build queue'
        delete 'to_build/pop' do
          $jobs_queues[:to_build].pop || {}
        end

        desc 'update job progress'
        params do
          requires :job, type: Hash
          requires :event_name, type: String
          requires :message, type: Hash
          requires :sent_at, type: Integer
        end
        patch ":id/progress" do
          # TODO only accept notification with newer timestamp

          case params[:job][:type]
          when 'config'
            case params[:event_name]
            when 'succeed'
              project = Project.find params[:job][:project][:id]
              project.update! config: JSON.parse(params[:message][:parsed_config])
            when 'error_occur'
              raise 'Project config parsing failed.'
            end

            status :ok
            return
          when 'build'
            distribution = Distribution.find params[:job][:distribution][:id]

            # ignore norification from expired job
            unless distribution.current_building_job_id == params[:job][:id]
              status :conflict
              return
            end

            case params[:event_name]
            when 'start_building'
              distribution.start_building if distribution.may_start_building?
            when 'succeed'
              distribution.succeed if distribution.may_succeed?
              distribution.url = params[:message][:uploaded_url]
            when 'error_occur'
              distribution.error_occur
              distribution.progress_message = params[:message][:progress_message]
            when 'minor_update'
              # not a major state progress
              distribution.progress_message = params[:message][:progress_message]
            else
              raise 'Unknown event'
            end

            distribution.save!

            status :ok
            return
          end
        end
      end
    end
  end
end

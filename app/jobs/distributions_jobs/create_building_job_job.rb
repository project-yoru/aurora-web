class DistributionsJobs::CreateBuildingJobJob < ApplicationJob
  queue_as :default

  def perform distribution
    logger.info "Sending request to build server for distribution #{distribution.id}"

    conn = Faraday.new( url: Rails.application.secrets.build_server[:url] ) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.post do |req|
      req.url '/v1/building_jobs'
      req.headers['Content-Type'] = 'application/json'

      req.body = {
        distribution: {
          id: distribution.id,
          platform: distribution.platform,
          source_type: distribution.project.source_type,
          github_repo_path: distribution.project.github_repo_path
        }
      }.to_json
    end

    logger.info "response: #{response.body}"
    if response.status == 201
      distribution.current_building_job_id = ( JSON.parse response.body )['job_id']
    else
      raise 'Building Job created failed.'
    end
  end
end

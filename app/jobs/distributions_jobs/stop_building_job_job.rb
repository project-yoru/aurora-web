class DistributionsJobs::StopBuildingJobJob < ApplicationJob
  queue_as :default

  def perform job_id
    logger.info "Sending request to build server to stop building job #{job_id}"

    conn = Faraday.new( url: Rails.application.secrets.build_server[:url] ) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.delete do |req|
      req.url "/v1/building_jobs/#{job_id}"
    end

    logger.info "response: #{response.body}"
  end
end

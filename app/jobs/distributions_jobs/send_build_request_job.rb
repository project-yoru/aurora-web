class DistributionsJobs::SendBuildRequestJob < ApplicationJob
  queue_as :default

  def perform distribution
    # TODO
    logger.info 'SENDING BUILD REQUEST'
  end
end

class Distribution < ApplicationRecord
  include AASM

  belongs_to :project

  aasm column: :state do
    state :initialized, initial: true
    state :pending
    state :building

    event :start, before: :save_in_queue do
      transitions from: :initialized, to: :pending
    end

    event :build, before: :send_building_request do
      transitions from: :pending, to: :building
    end
  end

  def save_in_queue
    BuildingQueue.push self
  end

  def send_building_request
    DistributionsJobs::SendBuildingRequestJob.perform_later self
  end

end

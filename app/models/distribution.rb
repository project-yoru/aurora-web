class Distribution < ApplicationRecord
  include AASM

  belongs_to :project

  aasm column: :state do
    state :initialized, initial: true
    state :pending
    state :building

    event :start do
      before do
        # save in BuildingQueue
        BuildingQueue.push self
      end

      transitions from: :initialized, to: :pending

      after do
        BuildingQueue.pop_and_build if BuildingQueue.size == 1
      end
    end

    event :build, before: :send_building_request do
      transitions from: :pending, to: :building
    end
  end

  def send_building_request
    DistributionsJobs::SendBuildRequestJob.perform_later self
  end

end

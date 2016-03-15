class Distribution < ApplicationRecord
  include AASM

  belongs_to :project

  aasm column: :state do
    # state and event for error handling

    state :initialized, initial: true
    state :pending
    state :pulling
    state :building
    state :uploading
    state :successful
    state :failed

    event :pend, after: :send_building_request do
      transitions from: :initialized, to: :pending
    end

    event :started_pulling do
      transitions from: :pending, to: :pulling
    end

    event :started_building do
      transitions from: [:pending, :pulling], to: :building
    end

    event :started_uploading do
      transitions from: [:pending, :pulling, :building], to: :uploading
    end

    event :succeeded do
      transitions from: [:pending, :pulling, :building, :uploading ], to: :successful
    end

    event :failure_occured do
      transitions from: [:pending, :pulling, :building, :uploading ], to: :failed
    end

  end

  def send_building_request
    DistributionsJobs::SendBuildRequestJob.perform_later self
  end

end

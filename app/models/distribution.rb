class Distribution < ApplicationRecord
  include AASM

  belongs_to :project

  # TODO simplify the state machine, use message instead of state
  aasm column: :state do
    # state and event for error handling

    state :initialized, initial: true
    state :pending
    state :building
    state :successful
    state :failed

    event :pend, after: :send_building_request do
      transitions from: :initialized, to: :pending
    end

    event :start_building do
      transitions from: :pending, to: :building
    end

    event :succeed do
      transitions from: [:building], to: :successful
    end

    event :error_occur do
      transitions from: [:pending, :building], to: :failed
    end

  end

  def send_building_request
    DistributionsJobs::SendBuildRequestJob.perform_later self
  end

end

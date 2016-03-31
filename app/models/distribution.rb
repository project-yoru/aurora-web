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
    state :halted

    event :pend, after: :create_building_job do
      transitions from: %i(initialized failed halted), to: :pending
    end

    event :start_building do
      transitions from: :pending, to: :building
    end

    event :succeed do
      transitions from: :building, to: :successful
    end

    event :error_occur do
      transitions from: %i(pending building), to: :failed
    end

    event :halt, after: :stop_current_building_job do
      transitions from: %i(pending building), to: :halted
    end
  end

  def current_building_job_id
    $redis.get "distribution_#{id}_current_building_job_id"
  end

  def current_building_job_id= job_id
    $redis.set "distribution_#{id}_current_building_job_id", job_id
  end

  private

  def create_building_job
    stop_current_building_job
    DistributionsJobs::CreateBuildingJobJob.perform_later self
  end

  def stop_current_building_job
    return unless got_job_id = current_building_job_id
    current_building_job_id = nil
    DistributionsJobs::StopBuildingJobJob.perform_later got_job_id
  end

end

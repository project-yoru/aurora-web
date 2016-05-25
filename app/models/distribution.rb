# TODO make [project_id, platform] a index

class Distribution < ApplicationRecord
  include AASM

  SUPPORTED_PLATFORMS = %w( web android )

  belongs_to :project

  validates :platform, inclusion: { in: SUPPORTED_PLATFORMS }

  aasm column: :state do
    # state and event for error handling

    state :initialized, initial: true
    state :pending
    state :building
    state :successful
    state :failed
    state :halted

    event :pend, after: :pend_building_job_in_queue do
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

  def pend_building_job_in_queue
    stop_current_building_job
    self.current_building_job_id = $jobs_queues[:to_build].push type: :build, distribution: self
  end

  def stop_current_building_job
    unless $jobs_queues[:to_build].remove! self
      # TODO halt running job on remote
      # create halt_building_queue like build_queue
    end
    current_building_job_id = nil
  end

end

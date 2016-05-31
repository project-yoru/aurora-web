# TODO got no stop current and redo mechanism

class OnlinePreview < ApplicationRecord
  include AASM

  belongs_to :project

  aasm column: :state do
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

  # TODO make related methods a module
  def current_building_job_id
    $redis.get "online_preview_#{id}_current_building_job_id"
  end

  def current_building_job_id= job_id
    $redis.set "online_preview_#{id}_current_building_job_id", job_id
  end

  private

  def pend_building_job_in_queue
    stop_current_building_job
    self.current_building_job_id = $jobs_queues[:to_build].push type: :build_online_preview, online_preview: self
  end

  def stop_current_building_job
    # TODO
    # unless $jobs_queues[:to_build].remove! self
    #   # TODO halt running job on remote
    #   # create halt_building_queue like build_queue
    # end
    # current_building_job_id = nil
  end

end

class Distribution < ApplicationRecord
  include AASM

  belongs_to :project

  aasm column: :state do
    state :initialized, initial: true
    state :building

    event :build do
      transitions from: :initialized, to: :building
    end
  end

  def start_building
    puts state
  end
end

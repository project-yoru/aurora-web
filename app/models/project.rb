class Project < ActiveRecord::Base
  belongs_to :user
  has_many :distributions, dependent: :destroy

  # TODO validate git_repo_path

  after_create :create_distributions
  after_create :fetch_config

  def create_distributions
    platforms.each do |p|
      d = distributions.create platform: p
      d.pend!
    end
  end

  def fetch_config
    $jobs_queues[:to_build].push type: :config, project: self
  end
end

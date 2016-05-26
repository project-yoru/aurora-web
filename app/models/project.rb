class Project < ActiveRecord::Base
  belongs_to :user
  has_many :distributions, dependent: :destroy

  # TODO validate git_repo_path
  validate :platforms_are_valid
  validate :has_necessary_platforms

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

  private

  def platforms_are_valid
    platforms.each do |p|
      unless Distribution::SUPPORTED_PLATFORMS.include? p
        errors.add :platforms, 'invalid'
        return
      end
    end
  end

  def has_necessary_platforms
    necessary_platform = 'web'

    unless platforms.include? necessary_platform
      errors.add :platforms, 'lack of necessary ones'
      return
    end
  end
end

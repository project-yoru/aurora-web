class Project < ApplicationRecord
  NECESSARY_PLATFORMS = %w(online_preview web)

  belongs_to :user
  has_many :distributions, dependent: :destroy

  # TODO validate git_repo_path
  # TODO validate can have most one distribution for each platform
  validate :platforms_are_valid
  validate :has_necessary_platforms

  after_create :fetch_config
  after_create :create_and_pend_distributions

  def online_preview
    distributions.with_platform('online_preview').first
  end

  def fetch_config
    $jobs_queues[:to_build].push type: :config, project: self
  end

  def create_and_pend_distributions
    platforms.each do |p|
      d = distributions.build platform: p
      d.pend!
    end
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
    NECESSARY_PLATFORMS.each do |platform|
      unless platforms.include? platform
        errors.add :platforms, 'lack of necessary ones'
        return
      end
    end

  end
end

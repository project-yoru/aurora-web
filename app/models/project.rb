class Project < ActiveRecord::Base
  belongs_to :user
  has_many :distributions, dependent: :destroy
  has_one :online_preview, dependent: :destroy

  # TODO validate git_repo_path
  validate :platforms_are_valid
  validate :has_necessary_platforms

  after_create :fetch_config
  after_create :do_create_online_preview
  after_create :do_create_distributions

  def fetch_config
    $jobs_queues[:to_build].push type: :config, project: self
  end

  def do_create_online_preview
    online_preview = build_online_preview
    online_preview.pend!
  end

  def do_create_distributions
    platforms.each do |p|
      d = distributions.create platform: p
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
    necessary_platform = 'web'

    unless platforms.include? necessary_platform
      errors.add :platforms, 'lack of necessary ones'
      return
    end
  end
end

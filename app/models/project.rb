class Project < ActiveRecord::Base
  belongs_to :user
  has_many :distributions, dependent: :destroy

  # TODO validate git_repo_path
  # https://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails

  after_create :create_distributions

  def create_distributions
    platforms.each do |p|
      d = distributions.create platform: p
      d.pend!
    end
  end

  def distrubution platform
    # TODO make [project_id, platform] a index
    distributions.where(platform: platform).first
  end

end

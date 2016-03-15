class Project < ActiveRecord::Base
  belongs_to :user
  has_many :distributions, dependent: :destroy

  # TODO validate github_repo_path

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

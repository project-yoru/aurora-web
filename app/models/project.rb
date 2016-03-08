class Project < ActiveRecord::Base
  belongs_to :user
  has_many :distributions

  after_create :create_distributions

  def create_distributions
    platforms.each do |p|
      d = distributions.create platform: p
      d.start
    end
  end

  def distrubution platform
    # TODO make [project_id, platform] a index
    distributions.where(platform: platform).first
  end

end

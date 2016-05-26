class ConcatNecessaryPlatformsForProjects < ActiveRecord::Migration[5.0]
  def change
    Project.where.not("'web' = ANY (platforms)").each do |p|
      p.platforms << 'web'
      p.save!
    end
  end
end

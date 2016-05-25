class AddConfigToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :config, :jsonb, default: {}
  end
end

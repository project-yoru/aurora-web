class MakeProjectAdaptiveForAllGitRepo < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :source_type
    rename_column :projects, :github_repo_path, :git_repo_path
  end
end

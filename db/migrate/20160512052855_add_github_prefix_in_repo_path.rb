class AddGithubPrefixInRepoPath < ActiveRecord::Migration[5.0]
  def change
    Project.find_each do |p|
      p.update git_repo_path: "https://github.com/#{p.git_repo_path}"
    end
  end
end

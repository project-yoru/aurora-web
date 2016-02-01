class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :user, index: true, foreign_key: true

      t.string :name, null: false
      t.string :source_type, null: false
      t.string :github_repo_path, null: false

      t.column :platforms, :string, array: true

      t.timestamps
    end
  end
end

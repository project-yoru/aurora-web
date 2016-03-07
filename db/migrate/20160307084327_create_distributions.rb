class CreateDistributions < ActiveRecord::Migration[5.0]
  def change
    create_table :distributions do |t|
      t.references :project, foreign_key: true
      t.string :platform, null: false
      t.string :state, null: false, default: 'initialized'

      t.timestamps
    end
  end
end

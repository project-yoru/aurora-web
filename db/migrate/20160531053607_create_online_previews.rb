class CreateOnlinePreviews < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    create_table :online_previews, id: :uuid do |t|
      t.references :project, index: true
      t.string :state, default: 'initialized'
      t.string :progress_message
      t.string :url

      t.timestamps
    end
  end
end

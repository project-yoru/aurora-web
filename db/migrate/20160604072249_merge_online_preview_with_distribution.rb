class MergeOnlinePreviewWithDistribution < ActiveRecord::Migration[5.0]
  def change
    rename_column :distributions, :uploaded_archive_url, :url

    OnlinePreview.all.each do |preview|
      # create 
      preview.project.distributions.create({
        platform: 'online_preview',
        state: preview.state,
        progress_message: preview.progress_message,
        url: preview.url
      })
    end

    drop_table :online_previews
  end
end

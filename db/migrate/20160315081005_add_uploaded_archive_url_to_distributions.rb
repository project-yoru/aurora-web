class AddUploadedArchiveUrlToDistributions < ActiveRecord::Migration[5.0]
  def change
    add_column :distributions, :uploaded_archive_url, :string
  end
end

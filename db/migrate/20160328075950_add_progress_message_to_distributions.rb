class AddProgressMessageToDistributions < ActiveRecord::Migration[5.0]
  def change
    add_column :distributions, :progress_message, :string
  end
end

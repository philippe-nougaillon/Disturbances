class AddGareIdToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :gare_id, :integer
  end
end

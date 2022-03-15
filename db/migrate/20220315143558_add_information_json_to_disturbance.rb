class AddInformationJsonToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :information_payload, :jsonb
  end
end

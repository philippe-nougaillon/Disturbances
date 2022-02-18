class AddProvenanceToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :provenance, :string
  end
end

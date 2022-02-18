class AddArriveeToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :arrivée, :string
  end
end

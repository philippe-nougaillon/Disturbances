class AddSensToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :sens, :string
  end
end

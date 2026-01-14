class AddIndexToDisturbances < ActiveRecord::Migration[7.0]
  def change
    add_index :disturbances, :perturbation
  end
end

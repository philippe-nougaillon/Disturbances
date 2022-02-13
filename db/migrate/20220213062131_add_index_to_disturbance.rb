class AddIndexToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_index :disturbances, [:date, :train, :départ], unique: true
  end
end

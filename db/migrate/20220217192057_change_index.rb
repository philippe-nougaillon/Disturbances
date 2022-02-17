class ChangeIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :disturbances, [:date, :train, :départ]
    add_index :disturbances, [:date, :train, :départ, :raison], unique: true
  end
end

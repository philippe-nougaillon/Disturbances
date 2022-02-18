class ChangeIndexBis < ActiveRecord::Migration[7.0]
  def change
    remove_index :disturbances, [:date, :train, :départ, :raison]
    add_index :disturbances, [:date, :sens, :train, :départ, :arrivée, :raison], unique: true, name: 'super_index_uniq'
  end
end

class RemoveIndexBis < ActiveRecord::Migration[7.0]
  def change
    remove_index :disturbances, [:date, :sens, :train, :départ, :arrivée, :raison],  name: 'super_index_uniq'
  end
end

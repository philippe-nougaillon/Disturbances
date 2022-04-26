class AddPerturbationToSuperIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :disturbances, name: 'super_index_uniq'
    add_index :disturbances, 
        [:date, :sens, :train, :perturbation], 
        unique: true, 
        name: 'super_index_uniq'
  end
end

class AddNewSuperIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :disturbances, 
              [:date, :sens, :train, :raison], 
              unique: true, 
              name: 'super_index_uniq'
  end
end

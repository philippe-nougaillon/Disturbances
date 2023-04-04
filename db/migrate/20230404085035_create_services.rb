class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.date :date
      t.string :train
      t.string :horaire
      t.string :destination

      t.timestamps
    end
    add_index :services, [:date, :train], unique: true
  end
end

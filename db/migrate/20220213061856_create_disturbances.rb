class CreateDisturbances < ActiveRecord::Migration[7.0]
  def change
    create_table :disturbances do |t|
      t.string :date
      t.string :train
      t.string :départ
      t.string :destination
      t.string :voie
      t.string :raison

      t.timestamps
    end
  end
end

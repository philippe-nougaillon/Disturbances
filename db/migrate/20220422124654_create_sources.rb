class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :url
      t.string :gare
      t.string :sens

      t.timestamps
    end
  end
end

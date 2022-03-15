class AddDepartPrevuReelToDisturbances < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :départ_prévu, :string
    add_column :disturbances, :départ_réel, :string
  end
end

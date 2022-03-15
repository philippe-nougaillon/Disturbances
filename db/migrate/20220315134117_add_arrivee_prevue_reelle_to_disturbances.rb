class AddArriveePrevueReelleToDisturbances < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :arrivée_prévue, :string
    add_column :disturbances, :arrivée_réelle, :string
  end
end

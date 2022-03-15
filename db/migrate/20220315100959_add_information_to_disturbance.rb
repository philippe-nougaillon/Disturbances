class AddInformationToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :information, :string
  end
end

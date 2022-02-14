class AddOrigineToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :origine, :string
  end
end

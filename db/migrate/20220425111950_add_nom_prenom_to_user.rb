class AddNomPrenomToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nom, :string
    add_column :users, :prénom, :string
  end
end

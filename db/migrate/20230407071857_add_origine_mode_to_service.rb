class AddOrigineModeToService < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :origine, :string
    add_column :services, :mode, :string
  end
end

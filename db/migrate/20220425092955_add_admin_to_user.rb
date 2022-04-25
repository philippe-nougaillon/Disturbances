class AddAdminToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    User.update_all(admin: false)
  end
end

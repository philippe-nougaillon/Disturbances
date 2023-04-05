class CreateUsersSourcesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :sources do |t|
      t.index :user_id
      t.index :source_id
    end
  end
end

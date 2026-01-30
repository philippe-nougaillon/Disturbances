class AddDiscardedAtToDisturbances < ActiveRecord::Migration[7.0]
  def change
    add_column :disturbances, :discarded_at, :datetime
    add_index :disturbances, :discarded_at
  end
end

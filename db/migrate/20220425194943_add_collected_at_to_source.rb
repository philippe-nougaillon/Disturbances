class AddCollectedAtToSource < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :collected_at, :datetime
  end
end

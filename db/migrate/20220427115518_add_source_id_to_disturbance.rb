class AddSourceIdToDisturbance < ActiveRecord::Migration[7.0]
  def change
    add_reference :disturbances, :source, null: false, foreign_key: true
  end
end

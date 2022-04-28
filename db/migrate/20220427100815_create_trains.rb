class CreateTrains < ActiveRecord::Migration[7.0]
  def change
    create_view :trains, materialized: true
  end
end

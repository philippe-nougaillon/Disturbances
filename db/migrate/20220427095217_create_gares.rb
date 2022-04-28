class CreateGares < ActiveRecord::Migration[7.0]
  def change
    create_view :gares, materialized: true
  end
end

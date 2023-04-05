class CreateCancelleds < ActiveRecord::Migration[7.0]
  def change
    create_view :cancelleds, materialized: true
  end
end

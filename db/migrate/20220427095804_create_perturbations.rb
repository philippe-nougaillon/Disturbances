class CreatePerturbations < ActiveRecord::Migration[7.0]
  def change
    create_view :perturbations, materialized: true
  end
end

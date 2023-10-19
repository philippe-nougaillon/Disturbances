class RenameTrainToNumeroService < ActiveRecord::Migration[7.0]
  def change
    rename_column :services, :train, :numéro_service
  end
end

class CreateInfos < ActiveRecord::Migration[7.0]
  def change
    create_view :infos, materialized: true
  end
end

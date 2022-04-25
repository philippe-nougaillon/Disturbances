# == Schema Information
#
# Table name: disturbances
#
#  id                  :bigint           not null, primary key
#  arrivée             :string
#  arrivée_prévue      :string
#  arrivée_réelle      :string
#  date                :string
#  destination         :string
#  départ              :string
#  départ_prévu        :string
#  départ_réel         :string
#  information         :string
#  information_payload :jsonb
#  origine             :string
#  provenance          :string
#  raison              :string
#  sens                :string
#  train               :string
#  voie                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  gare_id             :integer
#
# Indexes
#
#  super_index_uniq  (date,sens,train,raison) UNIQUE
#
class Disturbance < ApplicationRecord
    
    paginates_per 10
    default_scope { order('created_at DESC') }
        
end

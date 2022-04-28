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
#  perturbation        :string
#  provenance          :string
#  raison              :string
#  sens                :string
#  train               :string
#  voie                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  gare_id             :integer
#  source_id           :bigint           not null
#
# Indexes
#
#  index_disturbances_on_source_id  (source_id)
#  super_index_uniq                 (date,sens,train,perturbation) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (source_id => sources.id)
#
require "test_helper"

class DisturbanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

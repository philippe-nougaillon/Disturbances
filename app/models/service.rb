# == Schema Information
#
# Table name: services
#
#  id             :bigint           not null, primary key
#  date           :date
#  destination    :string
#  horaire        :string
#  mode           :string
#  numéro_service :string
#  origine        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_services_on_date_and_numéro_service  (date,numéro_service) UNIQUE
#
class Service < ApplicationRecord
  default_scope -> { order("services.created_at DESC") }
end

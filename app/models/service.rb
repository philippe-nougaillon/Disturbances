# == Schema Information
#
# Table name: services
#
#  id          :bigint           not null, primary key
#  date        :date
#  destination :string
#  horaire     :string
#  train       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_services_on_date_and_train  (date,train) UNIQUE
#
class Service < ApplicationRecord
  default_scope -> { order(:date, :horaire) }
end

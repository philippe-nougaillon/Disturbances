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
require 'rails_helper'

RSpec.describe Service, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

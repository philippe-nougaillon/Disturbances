# == Schema Information
#
# Table name: sources
#
#  id           :bigint           not null, primary key
#  collected_at :datetime
#  gare         :string
#  sens         :string
#  url          :string
#  url2         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Source, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: sources
#
#  id           :bigint           not null, primary key
#  collected_at :datetime
#  gare         :string
#  sens         :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Source < ApplicationRecord
  audited except: :collected_at
end
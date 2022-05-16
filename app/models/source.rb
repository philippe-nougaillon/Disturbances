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

  has_many :disturbances

  default_scope { order(:gare, 'sources.sens DESC') }
  paginates_per 100

  def last_disturbance
    self.disturbances.where("DATE(disturbances.created_at) = ?", Date.today).first
  end

end
# == Schema Information
#
# Table name: sources_users
#
#  source_id :bigint           not null, primary key
#  user_id   :bigint           not null, primary key
#
# Indexes
#
#  index_sources_users_on_source_id  (source_id)
#  index_sources_users_on_user_id    (user_id)
#
class SourcesUser < ApplicationRecord
  self.primary_keys = :source_id, :user_id

  belongs_to :source
  belongs_to :user

end

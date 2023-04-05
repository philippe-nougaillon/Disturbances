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
require 'rails_helper'

RSpec.describe SourcesUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

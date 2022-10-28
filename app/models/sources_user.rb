class SourcesUser < ApplicationRecord
  self.primary_keys = :source_id, :user_id

  belongs_to :source
  belongs_to :user

end

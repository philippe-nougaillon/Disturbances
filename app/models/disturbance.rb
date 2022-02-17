class Disturbance < ApplicationRecord
    paginates_per 10
    default_scope { order('created_at DESC') }
end

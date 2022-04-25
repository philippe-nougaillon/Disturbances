class Source < ApplicationRecord
  audited except: :collected_at
end

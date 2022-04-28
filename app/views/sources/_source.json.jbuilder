json.extract! source, :id, :url, :gare, :sens, :created_at, :updated_at
json.url source_url(source, format: :json)

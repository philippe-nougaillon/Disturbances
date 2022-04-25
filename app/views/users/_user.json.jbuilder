json.extract! user, :id, :nom, :prénom, :email, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)

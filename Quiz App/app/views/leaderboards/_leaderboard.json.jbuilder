json.extract! leaderboard, :id, :user_email, :quiz_id, :score, :state, :created_at, :updated_at
json.url leaderboard_url(leaderboard, format: :json)

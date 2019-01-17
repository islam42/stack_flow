json.extract! question, :id, :content, :total_votes, :created_at, :updated_at
json.url question_url(question, format: :json)

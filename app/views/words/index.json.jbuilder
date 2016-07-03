json.array!(@words) do |word|
  json.extract! word, :id, :name, :desc, :user, :removed, :created_at, :updated_at
  json.url word_url(word, format: :json)
end

json.array!(@words) do |word|
  json.extract! word, :id, :name, :desc, :user, :removed
  json.url word_url(word, format: :json)
end

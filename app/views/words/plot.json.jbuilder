json.array!(@plots) do |plot|
  json.extract! plot, :user, :date, :count
end

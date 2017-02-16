json.array!(@total_ranks) do |total_rank|
  json.extract! total_rank, :user, :number
end

json.array!(@monthly_ranks) do |monthly_rank|
  json.extract! monthly_rank, :user, :number
end

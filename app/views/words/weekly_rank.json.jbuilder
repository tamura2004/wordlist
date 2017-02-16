json.array!(@weekly_ranks) do |weekly_rank|
  json.extract! weekly_rank, :user, :number
end

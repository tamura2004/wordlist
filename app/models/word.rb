class Word < ActiveRecord::Base
  validates :name, presence: true
  validates :user, presence: true
  validates :name, uniqueness: {scope: [:user, :removed], message: "は既に登録済です"}

  scope :rank, -> {
  	select("words.user,count(*) as number")
  	.group("words.user")
  	.order("number desc")
  }

  scope :monthly_rank, -> {
  	rank.where("updated_at > ?", 1.months.ago)
  }

  scope :weekly_rank, -> {
  	rank.where("updated_at > ?", 1.weeks.ago)
  }

end

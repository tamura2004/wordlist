class Word < ActiveRecord::Base
  validates :name, presence: true
  validates :user, presence: true
  validates :name, uniqueness: {scope: [:user, :removed], message: "has already been taken with the same user and removed state."}
end

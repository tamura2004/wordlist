class Word < ActiveRecord::Base
  validates :name, presence: true
  validates :user, presence: true
  validates :name, uniqueness: {scope: [:user, :removed]}
end

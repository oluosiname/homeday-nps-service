class Nps < ApplicationRecord
  validates :score, :touchpoint, presence: true
  validates :score, inclusion: { in: 0..10, message: 'must be a number between 0 and 10' }
end

class Nps < ApplicationRecord
  validates :score, :touchpoint, :object_id, :object_class, :respondent_class, :respondent_id, presence: true
  validates :score, inclusion: { in: 0..10, message: 'must be a number between 0 and 10' }
  validates :score,
            uniqueness: {
              scope: [:touchpoint, :object_class, :object_id, :respondent_class, :respondent_id],
              message: 'already recorded'
            }
end

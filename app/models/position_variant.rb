class PositionVariant < ApplicationRecord
  belongs_to :position

  enum :role, {
    attacker: 0,
    defender: 1,
    neutral: 2,
    mutual: 3
  }

  validates :name, presence: true,
                   uniqueness: { scope: :position_id, case_sensitive: false }
  validates :role, presence: true
end

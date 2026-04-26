class Position < ApplicationRecord
  has_many :variants, class_name: "PositionVariant", dependent: :destroy
  has_many :aliases, as: :aliasable


  enum :category, {
    guard: 0,
    pin: 1,
    back: 2,
    leg_entanglement: 3,
    neutral: 4,
    scramble: 5,
    turtle: 6
  }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :category, presence: true
end

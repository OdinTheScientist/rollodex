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

  scope :search, ->(query) {
    if query.length >= 5
      where("word_similarity(:query, name) > 0.35 OR name ILIKE :pattern",
            query: query, pattern: "%#{query}%")
    else
      where("name ILIKE :pattern", pattern: "%#{query}%")
    end
  }
end

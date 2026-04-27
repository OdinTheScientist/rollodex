class Technique < ApplicationRecord
  # Starting positions
  has_many :technique_starting_position_variants
  has_many :starting_position_variants,
           through: :technique_starting_position_variants,
           source: :position_variant

  # Ending positions
  has_many :technique_ending_position_variants
  has_many :ending_position_variants,
           through: :technique_ending_position_variants,
           source: :position_variant
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :aliases, as: :aliasable

  enum :technique_type, {
    submission: 0,
    sweep: 1,
    pass: 2,
    escape: 3,
    takedown: 4,
    transition: 5,
    control: 6,
    recovery: 7
  }

  enum :gi_nogi, {
    both: 0,
    gi_only: 1,
    nogi_only: 2
  }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :technique_type, presence: true
  validates :gi_nogi, presence: true

  scope :search, ->(query) {
    if query.length >= 5
      where("word_similarity(:query, name) > 0.35 OR name ILIKE :pattern",
            query: query, pattern: "%#{query}%")
    else
      where("name ILIKE :pattern", pattern: "%#{query}%")
    end
  }
end

class Resource < ApplicationRecord
  has_many :techniques, through: :resource_techniques

    enum :resource_type, {
    video: 0,
    instructional_series: 1,
    article: 2,
    match_footage: 3,
    personal_note: 4
  }

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :resource_type, presence: true
end

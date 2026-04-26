class Alias < ApplicationRecord
  belongs_to :aliasable, polymorphic: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

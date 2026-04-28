# == Schema Information
#
# Table name: position_variants
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  role        :integer          default("attacker"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position_id :bigint           not null
#
# Indexes
#
#  index_position_variants_on_position_id           (position_id)
#  index_position_variants_on_position_id_and_name  (position_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (position_id => positions.id)
#
class PositionVariant < ApplicationRecord
  belongs_to :position

  enum :role, {
    attacker: 0,
    defender: 1,
    neutral: 2,
    mutual: 3
  }

  has_many :technique_starting_position_variants

  has_many :available_techniques,
          through: :technique_starting_position_variants,
          source: :technique
  has_many :aliases, as: :aliasable

  validates :name, presence: true,
                   uniqueness: { scope: :position_id, case_sensitive: false }
  validates :role, presence: true
end

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
require "test_helper"

class PositionVariantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: technique_ending_position_variants
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  position_variant_id :bigint           not null
#  technique_id        :bigint           not null
#
# Indexes
#
#  idx_on_position_variant_id_83380ac600                     (position_variant_id)
#  index_ending_variants_on_technique_and_position_variant   (technique_id,position_variant_id) UNIQUE
#  index_technique_ending_position_variants_on_technique_id  (technique_id)
#
# Foreign Keys
#
#  fk_rails_...  (position_variant_id => position_variants.id)
#  fk_rails_...  (technique_id => techniques.id)
#
require "test_helper"

class TechniqueEndingPositionVariantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

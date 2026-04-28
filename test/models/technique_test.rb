# == Schema Information
#
# Table name: techniques
#
#  id             :bigint           not null, primary key
#  description    :text
#  gi_nogi        :integer          default("both"), not null
#  name           :string           not null
#  technique_type :integer          default("submission"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_techniques_on_gi_nogi         (gi_nogi)
#  index_techniques_on_name            (name) UNIQUE
#  index_techniques_on_name_trgm       (name) USING gin
#  index_techniques_on_technique_type  (technique_type)
#
require "test_helper"

class TechniqueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

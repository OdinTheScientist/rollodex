# == Schema Information
#
# Table name: positions
#
#  id          :bigint           not null, primary key
#  category    :integer          default("guard"), not null
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_positions_on_category   (category)
#  index_positions_on_name       (name) UNIQUE
#  index_positions_on_name_trgm  (name) USING gin
#
require "test_helper"

class PositionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

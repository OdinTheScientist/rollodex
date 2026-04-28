# == Schema Information
#
# Table name: resources
#
#  id              :bigint           not null, primary key
#  instructor_name :string
#  notes           :text
#  resource_type   :integer          default("video"), not null
#  title           :string           not null
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_resources_on_resource_type  (resource_type)
#  index_resources_on_title_trgm     (title) USING gin
#
require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: taggings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tag_id       :bigint           not null
#  technique_id :bigint           not null
#
# Indexes
#
#  index_taggings_on_tag_id                   (tag_id)
#  index_taggings_on_technique_id             (technique_id)
#  index_taggings_on_technique_id_and_tag_id  (technique_id,tag_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (technique_id => techniques.id)
#
require "test_helper"

class TaggingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

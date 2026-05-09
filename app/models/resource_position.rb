# == Schema Information
#
# Table name: resource_positions
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position_id :bigint           not null
#  resource_id :bigint           not null
#
# Indexes
#
#  index_resource_positions_on_position_id            (position_id)
#  index_resource_positions_on_resource_and_position  (resource_id,position_id) UNIQUE
#  index_resource_positions_on_resource_id            (resource_id)
#
# Foreign Keys
#
#  fk_rails_...  (position_id => positions.id)
#  fk_rails_...  (resource_id => resources.id)
#
class ResourcePosition < ApplicationRecord
  belongs_to :resource
  belongs_to :position
end

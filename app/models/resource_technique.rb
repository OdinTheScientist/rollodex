# == Schema Information
#
# Table name: resource_techniques
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  resource_id  :bigint           not null
#  technique_id :bigint           not null
#
# Indexes
#
#  index_resource_techniques_on_resource_and_technique  (resource_id,technique_id) UNIQUE
#  index_resource_techniques_on_resource_id             (resource_id)
#  index_resource_techniques_on_technique_id            (technique_id)
#
# Foreign Keys
#
#  fk_rails_...  (resource_id => resources.id)
#  fk_rails_...  (technique_id => techniques.id)
#
class ResourceTechnique < ApplicationRecord
  belongs_to :resource
  belongs_to :technique
end

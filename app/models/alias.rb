# == Schema Information
#
# Table name: aliases
#
#  id             :bigint           not null, primary key
#  aliasable_type :string           not null
#  name           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  aliasable_id   :bigint           not null
#
# Indexes
#
#  index_aliases_on_aliasable                        (aliasable_type,aliasable_id)
#  index_aliases_on_aliasable_type_and_aliasable_id  (aliasable_type,aliasable_id)
#  index_aliases_on_name                             (name)
#
class Alias < ApplicationRecord
  belongs_to :aliasable, polymorphic: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

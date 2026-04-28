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
class Resource < ApplicationRecord
  has_many :techniques, through: :resource_techniques

    enum :resource_type, {
    video: 0,
    instructional_series: 1,
    article: 2,
    match_footage: 3,
    personal_note: 4
  }

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :resource_type, presence: true
end

# == Schema Information
#
# Table name: resources
#
#  id              :bigint           not null, primary key
#  foundational    :boolean          default(FALSE), not null
#  gi_nogi         :integer          default("both"), not null
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
#  index_resources_on_gi_nogi        (gi_nogi)
#  index_resources_on_resource_type  (resource_type)
#  index_resources_on_title_trgm     (title) USING gin
#
class Resource < ApplicationRecord
  has_many :resource_techniques
  has_many :techniques, through: :resource_techniques
  has_many :resource_positions
  has_many :positions, through: :resource_positions

    enum :resource_type, {
    video: 0,
    instructional_series: 1,
    article: 2,
    match_footage: 3,
    personal_note: 4
  }

  enum :gi_nogi, { both: 0, gi_only: 1, nogi_only: 2 }

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :resource_type, presence: true

  def youtube_id
    return nil unless url.present?
    url.match(/(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})/)&.[](1)
  end
end

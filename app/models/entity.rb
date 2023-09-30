# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :citext           not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_entities_on_slug           (slug)
#  index_entities_on_type_and_slug  (type,slug) UNIQUE
#  index_entities_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Entity < ApplicationRecord
  include Slugged

  belongs_to :user

  has_many :entity_users
  has_many :users, through: :entity_users
  has_many :organisations
  has_many :job_descriptions, through: :organisations

  before_validation :maybe_set_slug

  validates :name, presence: true, length: { minimum: 3, maximum: 80 }
  validates :slug, presence: true, uniqueness: { scope: :type, case_sensitive: true, if: :will_save_change_to_slug? },
                   length: { minimum: 3, maximum: 100 }

  private

  def maybe_set_slug
    self.slug ||= name&.parameterize
  end
end

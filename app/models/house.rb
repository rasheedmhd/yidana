# frozen_string_literal: true

# == Schema Information
#
# Table name: organisations
#
#  id           :bigint           not null, primary key
#  company_size :string           not null
#  company_type :string           not null
#  country      :string           not null
#  description  :text
#  headline     :text             not null
#  industry     :string           default([]), not null, is an Array
#  joel_test    :string           default([]), not null, is an Array
#  name         :string           not null
#  slug         :citext           not null
#  website_url  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :bigint           not null
#
# Indexes
#
#  index_organisations_on_entity_id           (entity_id)
#  index_organisations_on_entity_id_and_slug  (entity_id,slug) UNIQUE
#  index_organisations_on_slug                (slug)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#
class House < ApplicationRecord
  include Slugged
  include ShrineStorage::Model

  serialize :country, Country


  belongs_to :entity

  has_many :job_descriptions

  has_one_attached :logo
  has_many_attached :docs

  before_validation :clean_up_lists
  before_validation :maybe_set_slug

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :slug, presence: true, uniqueness: { case_sensitive: true, if: :will_save_change_to_slug? },
                   length: { minimum: 3, maximum: 180 }
  validates :headline, presence: true, length: { maximum: 500 }
  validates :description, length: { maximum: 3000 }
  validates :country, presence: true, inclusion: { in: Country.collection }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name headline company_type company_size country] + super
  end

  private

  def maybe_set_slug
    self.slug ||= name&.parameterize
  end
end

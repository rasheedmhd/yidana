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
class Organisation < ApplicationRecord
  include Slugged

  serialize :company_type, CompanyType
  serialize :company_size, CompanySize
  serialize :country, Country
  serialize :industry, Industry
  serialize :joel_test, JoelTest

  belongs_to :entity

  has_many :job_descriptions

  before_validation :clean_up_lists
  before_validation :maybe_set_slug

  validates :name, presence: true, length: { minimum: 3, maximum: 150 }
  validates :slug, presence: true, uniqueness: { case_sensitive: true, if: :will_save_change_to_slug? },
                   length: { minimum: 3, maximum: 180 }
  validates :headline, presence: true, length: { maximum: 500 }
  validates :description, length: { maximum: 3000 }
  validates :website_url, url: true, allow_blank: true
  validates :company_type, presence: true, inclusion: { in: CompanyType.collection }
  validates :company_size, presence: true, inclusion: { in: CompanySize.collection }
  validates :country, presence: true, inclusion: { in: Country.collection }
  validates :industry, presence: true, length: { maximum: 3, too_long: 'has too many items (maximum is %<count>s items)' },
                       array: { presence: true, inclusion: { in: Industry.collection } }
  validates :joel_test, array: { presence: true, inclusion: { in: JoelTest.collection } }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name headline company_type company_size country industry] + super
  end

  private

  def maybe_set_slug
    self.slug ||= name&.parameterize
  end

  def clean_up_lists
    self.industry = industry&.compact&.select(&:present?) || []
    self.joel_test = joel_test&.compact&.select(&:present?) || []
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: organisations
#
#  id           :bigint           not null, primary key
#  benefits     :string           default([]), not null, is an Array
#  company_size :string           not null
#  company_type :string           not null
#  country      :string           not null
#  description  :text
#  headline     :text             not null
#  industry     :string           default([]), not null, is an Array
#  joel_test    :string           default([]), not null, is an Array
#  name         :string           not null
#  website_url  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :bigint           not null
#
# Indexes
#
#  index_organisations_on_entity_id  (entity_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#
class Organisation < ApplicationRecord
  serialize :company_type, CompanyType
  serialize :company_size, CompanySize
  serialize :country, Country
  serialize :industry, Industry
  serialize :joel_test, JoelTest

  belongs_to :entity

  before_validation :clean_up_lists

  validates :name, presence: true, length: { maximum: 150 }
  validates :headline, presence: true, length: { maximum: 500 }
  validates :description, length: { maximum: 3000 }
  validates :website_url, url: true, allow_blank: true
  validates :company_type, presence: true, inclusion: { in: CompanyType.collection }
  validates :company_size, presence: true, inclusion: { in: CompanySize.collection }
  validates :country, presence: true, inclusion: { in: Country.collection }
  validates :industry, presence: true, length: { maximum: 3, too_long: 'has too many items (maximum is %<count>s items)' },
                       array: { presence: true, inclusion: { in: Industry.collection } }
  validates :benefits, length: { maximum: 10, too_long: 'has too many items (maximum is %<count>s items)' }
  validates :joel_test, array: { presence: true, inclusion: { in: JoelTest.collection } }

  private

  def clean_up_lists
    self.industry = industry&.compact&.select(&:present?) || []
    self.benefits = benefits&.compact&.select(&:present?) || []
    self.joel_test = joel_test&.compact&.select(&:present?) || []
  end
end

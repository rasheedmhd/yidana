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
#  headline     :string
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
  t.belongs_to :entity

  before_validation :set_defaults
  before_validation :clean_up_lists

  validates :name, presence: true, length: { maximum: 150 }
  validates :headline, length: { maximum: 500 }
  validates :description, length: { maximum: 3000 }
  validates :website, url: true, allow_blank: true
  validates :company_type, inclusion: { in: CompanyType.keys }, allow_blank: true
  validates :company_size, inclusion: { in: CompanySize.keys }, allow_blank: true
  validates :country, inclusion: { in: Country.keys }, allow_blank: true
  validates :industry, length: { maximum: 3, too_long: 'has too many items (maximum is %<count>s items)' },
                       array: { presence: true, inclusion: { in: Industry.keys } }
  validates :benefits, length: { maximum: 10, too_long: 'has too many items (maximum is %<count>s items)' }
  validates :joel_test, array: { presence: true, inclusion: { in: JoelTest.keys } }

  private

  def set_defaults
    self.benefits = [] if benefits.nil?
    self.industry = [] if industry.nil?
    self.joel_test = [] if joel_test.nil?
  end

  def clean_up_lists
    self.industry = industry.select(&:present?)
    self.benefits = benefits.select(&:present?)
    self.joel_test = joel_test.select(&:present?)
  end
end

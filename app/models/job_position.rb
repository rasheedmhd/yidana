# frozen_string_literal: true

# == Schema Information
#
# Table name: job_positions
#
#  id                    :bigint           not null, primary key
#  description           :text             not null
#  experience_level      :string           default([]), not null, is an Array
#  job_role              :string           default([]), not null, is an Array
#  job_type              :string           not null
#  maximum_annual_salary :integer          not null
#  minimum_annual_salary :integer          not null
#  offers_equity         :boolean          default(FALSE), not null
#  relocation_assistance :boolean          default(FALSE), not null
#  technologies          :string           default([]), not null, is an Array
#  title                 :string           not null
#  visa_sponsorship      :boolean          default(FALSE), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  organisation_id       :bigint           not null
#
# Indexes
#
#  index_job_positions_on_organisation_id  (organisation_id)
#
# Foreign Keys
#
#  fk_rails_...  (organisation_id => organisations.id)
#
class JobPosition < ApplicationRecord
  serialize :job_role, JobRole
  serialize :experience_level, ExperienceLevel
  serialize :job_type, JobType
  serialize :technologies, Technology

  belongs_to :organisation
  belongs_to :entity, through: :organisation

  validates :title, presence: true
  validates :job_role, presence: true, length: { maximum: 3, too_long: 'has too many items (maximum is %<count>s items)' },
                       array: { presence: true, inclusion: { in: JobRole.collection } }
  validates :experience_level, presence: true,
                               length: { maximum: ExperienceLevel.collection.size,
                                         too_long: 'has too many items (maximum is %<count>s items)' },
                               array: { presence: true, inclusion: { in: ExperienceLevel.collection } }
  validates :job_type, presence: true, inclusion: { in: JobType.collection }
  validates :description, presence: true
  validates :minimum_annual_salary, presence: true, numericality: { greater_than: 0 }
  validates :maximum_annual_salary, presence: true, numericality: { greater_than_or_equal_to: :minimum_annual_salary }
  validates :technologies, length: { maximum: 5, too_long: 'has too many items (maximum is %<count>s items)' },
                           array: { presence: true, inclusion: { in: Technology.collection } }
  # validates :benefits, length: { maximum: 10, too_long: 'has too many items (maximum is %<count>s items)' }
end

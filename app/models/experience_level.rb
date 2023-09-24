# frozen_string_literal: true

# Experience levels
class ExperienceLevel
  include ::InMemoryHashCollection

  HASH = {
    '10': 'Student',
    '20': 'Junior',
    '30': 'Mid-Level',
    '40': 'Senior',
    '50': 'Lead',
    '60': 'Manager'
  }.stringify_keys.sort.to_h.freeze
end

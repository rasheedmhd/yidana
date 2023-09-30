# frozen_string_literal: true

# Job types
class JobType
  include InMemoryHashCollection

  HASH = {
    full_time: 'Full-time',
    contract: 'Contract',
    internship: 'Internship'
  }.stringify_keys.freeze
end

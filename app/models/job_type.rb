# frozen_string_literal: true

# Job types
class JobType
  class << self
    def all
      HASH
    end

    def keys
      KEYS
    end

    def [](key)
      HASH[key]
    end
  end

  HASH = {
    full_time: 'Full-time',
    contract: 'Contract',
    internship: 'Internship'
  }.stringify_keys.freeze

  KEYS = HASH.keys.freeze
end

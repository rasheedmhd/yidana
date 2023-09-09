# frozen_string_literal: true

# Experience levels
class ExperienceLevel
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

  # Leave gaps in keys so values can be inserted
  HASH = {
    '10' => 'Student',
    '20' => 'Junior',
    '30' => 'Mid-Level',
    '40' => 'Senior',
    '50' => 'Lead',
    '60' => 'Manager'
  }.sort.to_h.freeze

  KEYS = HASH.keys.freeze
end

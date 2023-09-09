# frozen_string_literal: true

# Company types
class CompanyType
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
    private: 'Private',
    public: 'Public',
    vc_funded: 'VC Funded',
    government: 'Government',
    ngo: 'Non-Governmental Organization'
  }.stringify_keys.freeze

  KEYS = HASH.keys.freeze
end

# frozen_string_literal: true

# Company types
class CompanyType
  include ::InMemoryHashCollection

  HASH = {
    private: 'Private',
    public: 'Public',
    vc_funded: 'VC Funded',
    government: 'Government',
    ngo: 'Non-Governmental Organization'
  }.stringify_keys.freeze
end

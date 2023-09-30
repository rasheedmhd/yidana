# frozen_string_literal: true

# Company sizez
class CompanySize
  include InMemoryHashCollection

  HASH = {
    A: '1-10',
    B: '11-50',
    C: '51-200',
    D: '201-500',
    E: '501-1000',
    F: '1001-5000',
    G: '5001-10,000',
    H: '10,001+'
  }.stringify_keys.freeze
end

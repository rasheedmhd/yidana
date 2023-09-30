# frozen_string_literal: true

# Industries
class Industry
  include InMemoryHashCollection

  HASH = {
    accounting: 'Accounting',
    advertising: 'Advertising/Public Relations',
    agribusiness: 'Agribusiness',
    air: 'Air',
    architecture: 'Architecture',
    auto: 'Auto',
    banking_and_finance: 'Banking & Finance',
    communications: 'Communications/Electronics',
    construction: 'Construction',
    education: 'Education',
    energy: 'Energy',
    entertainment: 'Entertainment',
    environment: 'Environment',
    food_and_beverage: 'Food & Beverage',
    gaming: 'Games',
    government: 'Government',
    health: 'Health',
    hospitality: 'Hospitality',
    human_rights: 'Human Rights',
    insurance: 'Insurance',
    internet_and_software: 'Internet & Software',
    legal: 'Law',
    manufacturing: 'Manufacturing',
    marine: 'Marine',
    media: 'Media',
    natural_resources: 'Natural Resources',
    non_profit: 'Non-profits',
    oil_and_gas: 'Oil & Gas',
    other: 'Other',
    publishing: 'Printing & Publishing',
    real_estate: 'Real Estate',
    religion: 'Religious Organization',
    service: 'Services',
    sports: 'Sports',
    telecom: 'Telecom Services & Equipment',
    transport: 'Transport'
  }.stringify_keys.sort.to_h.freeze
end

# frozen_string_literal: true

# This file is generate automatically
# Do not modify it by hand
# Add your customizations to `entity.rb` instead
FactoryBot.define do
  ### base factory
  factory :entity, class: 'Entity' do
    ## required attributes
    add_attribute(:name) { Faker::Name.name }
    add_attribute(:slug) { Faker::String.random(length: 3..100) }

    ## optional attributes
    add_attribute(:type) { nil }

    ## required associations
    with_user

    ## belongs_to traits
    trait :with_user do
      association :user, factory: :user
    end

    ## has_one traits
    ## has_many traits
    transient do
    end

    ## creates an instance with all the bells and whistles
    trait :complete do
    end
  end
end

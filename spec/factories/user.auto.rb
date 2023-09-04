# frozen_string_literal: true

# This file is generate automatically
# Do not modify it by hand
# Add your customizations to `user.rb` instead
FactoryBot.define do
  ### base factory
  factory :user, class: User do
    ## required attributes
    add_attribute(:email) { Faker::Internet.unique.email }

    ## optional attributes
    add_attribute(:status) { 1 }
    add_attribute(:password_hash) { nil }

    ## required associations

    ## belongs_to traits
    ## has_one traits
    trait :with_remember_key do
      association :remember_key, factory: :user_remember_key
    end

    trait :with_verification_key do
      association :verification_key, factory: :user_verification_key
    end

    trait :with_password_reset_key do
      association :password_reset_key, factory: :user_password_reset_key
    end

    trait :with_login_change_key do
      association :login_change_key, factory: :user_login_change_key
    end

    ## has_many traits
    transient do
    end

    ## creates an instance with all the bells and whistles
    trait :complete do
      with_remember_key
      with_verification_key
      with_password_reset_key
      with_login_change_key
    end
  end
end

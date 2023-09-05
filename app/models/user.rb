# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  email         :citext           not null
#  password_hash :string
#  status        :integer          default("unverified"), not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE WHERE (status = ANY (ARRAY[1, 2]))
#
class User < ApplicationRecord
  include Rodauth::Rails.model(:user)

  enum :status, { unverified: 1, verified: 2, closed: 3 }, validate: true, prefix: true

  has_many :entity_users
  has_many :entities, through: :entity_users

  validates :email, presence: true
end

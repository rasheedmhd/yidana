# frozen_string_literal: true

# == Schema Information
#
# Table name: entity_users
#
#  id         :bigint           not null, primary key
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entity_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_entity_users_on_entity_id              (entity_id)
#  index_entity_users_on_user_id                (user_id)
#  index_entity_users_on_user_id_and_entity_id  (user_id,entity_id) UNIQUE
#  unique_owner_role_in_entity                  (entity_id) UNIQUE WHERE (role = 0)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#  fk_rails_...  (user_id => users.id)
#
class EntityUser < ApplicationRecord
  enum :role, { owner: 0, admin: 1, operations: 2, reporter: 3 }, validate: true, suffix: true

  belongs_to :entity
  belongs_to :user

  validates :user, uniqueness: { scope: :entity, message: 'has already been added' }

  validates :role, presence: true
end

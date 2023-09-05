# frozen_string_literal: true

class CreateEntityUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :entity_users do |t|
      t.belongs_to :entity, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :role, limit: 1

      t.timestamps
    end

    add_index :entity_users, :entity_id, unique: true, where: 'role = 0', name: 'unique_owner_role_in_entity'
    add_index :entity_users, %i[user_id entity_id], unique: true
  end
end

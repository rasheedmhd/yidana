# frozen_string_literal: true

class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.citext :slug, null: false, index: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :entities, %i[type slug], unique: true
  end
end

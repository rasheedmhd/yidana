# frozen_string_literal: true

class CreateOrganisations < ActiveRecord::Migration[7.0]
  def change
    create_table :organisations do |t|
      t.belongs_to :entity, foreign_key: true, null: false
      t.string :name, null: false
      t.string :headline
      t.text :description
      t.string :website_url
      t.string :industry, array: true, null: false, default: []
      t.string :company_size, null: false
      t.string :company_type, null: false
      t.string :benefits, array: true, null: false, default: []
      t.string :joel_test, array: true, null: false, default: []
      t.string :country, null: false

      t.timestamps
    end
  end
end

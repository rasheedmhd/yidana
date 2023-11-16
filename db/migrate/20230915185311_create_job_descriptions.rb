# frozen_string_literal: true

class CreateJobDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :job_descriptions do |t|
      t.belongs_to :house, null: false, foreign_key: true
      t.string :title, null: false
      t.string :job_role, null: false
      t.string :experience_level, array: true, null: false, default: []
      t.string :job_type, null: false
      t.text :description, null: false
      t.integer :minimum_annual_salary, null: false
      t.integer :maximum_annual_salary, null: false
      t.boolean :offers_equity, null: false, default: false
      t.string :technologies, array: true, null: false, default: []
      t.boolean :visa_sponsorship, null: false, default: false
      t.boolean :relocation_assistance, null: false, default: false

      t.timestamps
    end
  end
end

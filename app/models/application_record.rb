# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :from_path_param, ->(param) { where(id: param) }

  class << self
    # Ransack

    def ransackable_attributes(_auth_object = nil)
      _ransackers.keys
    end

    def ransackable_associations(_auth_object = nil)
      [] # reflect_on_all_associations.map { |a| a.name.to_s }
    end

    def ransortable_attributes(auth_object = nil)
      ransackable_attributes(auth_object) + %w[id created_at updated_at]
    end

    def ransackable_scopes(_auth_object = nil)
      []
    end
  end
end

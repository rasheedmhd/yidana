# frozen_string_literal: true

module Organisations
  class AdvancedAction < OrganisationInteraction
    string :name

    def execute
      errors.merge!(resource.errors) unless resource.update(name:)
      resource
    end
  end
end

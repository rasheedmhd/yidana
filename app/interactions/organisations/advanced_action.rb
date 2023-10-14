# frozen_string_literal: true

module Organisations
  class AdvancedAction < OrganisationInteraction
    string :name

    def execute
      resource.update(name:)
      resource
    end
  end
end

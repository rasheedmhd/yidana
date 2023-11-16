# frozen_string_literal: true

module houses
  class AdvancedAction < HouseInteraction
    string :name

    def execute
      errors.merge!(resource.errors) unless resource.update(name:)
      resource
    end
  end
end

# frozen_string_literal: true

module houses
  class SimpleAction < HouseInteraction
    def execute
      if resource.name == 'Set By Simple Action'
        errors.add :resource, 'has already been updated'
      else
        errors.merge!(resource.errors) unless resource.update(name: 'Set By Simple Action')
      end
      resource
    end
  end
end

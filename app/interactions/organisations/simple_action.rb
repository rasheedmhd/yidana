# frozen_string_literal: true

module Organisations
  class SimpleAction < OrganisationInteraction
    def execute
      resource.update name: 'Simple Action'
      resource
    end
  end
end

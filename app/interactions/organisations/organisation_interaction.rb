# frozen_string_literal: true

module Organisations
  class OrganisationInteraction < ResourceInteraction
    object :resource, class: Organisation
  end
end

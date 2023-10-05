# frozen_string_literal: true

module EntityResources
  class OrganisationsController < ResourceController
    controller_for Organisation, :name_cont
  end
end

# frozen_string_literal: true

module EntityResources
  class HousesController < ResourceController
    controller_for House, :name_cont
  end
end

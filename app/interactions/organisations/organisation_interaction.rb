# frozen_string_literal: true

module houses
  class HouseInteraction < ResourceInteraction
    object :resource, class: House
  end
end

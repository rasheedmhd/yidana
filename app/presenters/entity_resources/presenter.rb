# frozen_string_literal: true

module EntityResources
  class Presenter
    def initialize(context)
      @context = context
    end

    private

    attr_reader :context

    def houses_selection
      context.entity.houses.all
    end
  end
end

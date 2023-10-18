# frozen_string_literal: true

module EntityResources
  class Presenter
    def initialize(context)
      @context = context
    end

    private

    attr_reader :context

    def organisations_selection
      context.entity.organisations.all
    end
  end
end

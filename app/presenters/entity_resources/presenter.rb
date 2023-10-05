# frozen_string_literal: true

module EntityResources
  class Presenter
    def initialize(entity:, user:)
      @entity = entity
      @user = user
    end

    private

    attr_reader :entity, :user

    def organisations_selection
      entity.organisations.all
    end
  end
end

# frozen_string_literal: true

module EntityResources
  class PolicyContext
    attr_reader :entity, :user

    def initialize(user:, entity:, parent: nil)
      @entity = entity
      @user = user
      @parent = parent
    end

    def parent
      @parent || @entity
    end
  end
end

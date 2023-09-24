# frozen_string_literal: true

module EntityResources
  class PolicyContext
    attr_reader :entity, :user

    def initialize(entity, user, parent: nil)
      @entity = entity
      @user = user
      @parent = parent
    end

    def parent
      @parent || @entity
    end
  end
end

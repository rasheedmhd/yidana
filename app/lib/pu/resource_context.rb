# frozen_string_literal: true

module Pu
  class ResourceContext
    attr_reader :user, :entity

    def initialize(user:, entity: nil, parent: nil)
      @user = user
      @entity = entity
      @parent = parent
    end

    def parent
      @parent || @entity
    end
  end
end

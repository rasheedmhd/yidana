# frozen_string_literal: true

module Pu
  module Policy
    module EntityResourcePolicy
      include ResourcePolicy

      def show?
        @record.entity.id == context.entity.id
      end

      def update?
        @record.entity.id == context.entity.id
      end
    end
  end
end

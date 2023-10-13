# frozen_string_literal: true

module Pu
  module Policy
    module Initializer
      def initialize(context, record)
        authorize!(context)

        @context = context
        @record = record
      end

      private

      attr_reader :context, :record

      def authorize!(context)
        raise Pundit::NotAuthorizedError, 'must be logged in' unless context && context.entity && context.user
      end
    end
  end
end

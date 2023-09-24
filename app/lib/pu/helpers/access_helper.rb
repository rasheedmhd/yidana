# frozen_string_literal: true

module Pu
  module Helpers
    module AccessHelper
      def can_perform?(record, action)
        can = policy(record).send action
        return false unless can

        block_given? ? yield : can
      end

      def can_read_field?(record, field)
        can = policy(record).permitted_attributes_for_show.include? field.to_sym
        return false unless can

        block_given? ? yield : can
      end
    end
  end
end

# frozen_string_literal: true

module Pu
  module Helpers
    module AccessHelper
      def can_perform?(_record, _action)
        can = true # TODO
        return false unless can

        block_given? ? yield : can
      end

      # def can_list?(_record, _field)
      #   can = true # TODO
      #   yield if can && block_given?
      #   can
      # end

      def can_read_field?(_record, _field)
        can = true # TODO
        return false unless can

        block_given? ? yield : can
      end

      # def can_write_field?(_record, _field)
      #   can = true # TODO
      #   return false unless can

      #   block_given? ? yield : can
      # end
    end
  end
end

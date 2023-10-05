# frozen_string_literal: true

#
# Sets the current parent in the :detect_current_parent before action
#
# Current parent is available via #current_parent
#
module EntityResources
  module Concerns
    module CurrentParent
      def self.included(base)
        base.send :helper_method, :current_parent
      end

      private

      def current_parent
        return unless parent_param_key.present?

        @current_parent ||= begin
          parent_name = parent_param_key.gsub(/_id$/, '')

          if respond_to?(:current_entity, true)
            parent_association = parent_name.pluralize.to_sym
            current_entity.send(parent_association).from_path_param(params[parent_param_key]).first!
          end
        end
      end

      def parent_param_key
        @parent_param_key ||= begin
          path_param_keys = params.keys.last(4) - %w[controller action entity_id id format]
          path_param_keys.select { |key| /_id$/.match? key }.last
        end
      end
    end
  end
end

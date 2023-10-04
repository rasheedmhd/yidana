# frozen_string_literal: true

module EntityResources
  module Concerns
    module ResourcePolicy
      include Concerns::ResourcePolicyInitializer

      def index?
        true
      end

      def show?
        @record.entity.id == context.entity.id
      end

      def create?
        true
      end

      def new?
        create?
      end

      def update?
        @record.entity.id == context.entity.id
      end

      def edit?
        update?
      end

      def destroy?
        true
      end

      def permitted_attributes_for_index
        permitted_attributes_for_read
      end

      def permitted_attributes_for_show
        permitted_attributes_for_read
      end

      def permitted_attributes_for_new
        permitted_attributes_for_create
      end

      def permitted_attributes_for_edit
        permitted_attributes_for_update
      end
    end
  end
end

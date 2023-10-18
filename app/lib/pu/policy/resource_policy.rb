# frozen_string_literal: true

module Pu
  module Policy
    module ResourcePolicy
      include Initializer

      def index?
        true
      end

      def show?
        true
      end

      def create?
        true
      end

      def new?
        create?
      end

      def update?
        true
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

      def permitted_associations
        []
      end

      def begin_resource_action?
        true
      end

      def commit_resource_action?
        true
      end
    end
  end
end

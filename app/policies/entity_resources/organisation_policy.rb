# frozen_string_literal: true

module EntityResources
  class OrganisationPolicy
    include Concerns::ResourcePolicy

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
      %i[name headline company_type company_size country created_at updated_at]
    end

    def permitted_attributes_for_show
      %i[name headline description website_url company_type company_size country created_at updated_at]
    end

    def permitted_attributes_for_create
      %i[name headline description website_url company_type company_size industry country joel_test]
    end

    def permitted_attributes_for_update
      permitted_attributes_for_create
    end

    class Scope
      include Concerns::ResourcePolicy

      def resolve
        @context.parent.organisations
      end
    end
  end
end

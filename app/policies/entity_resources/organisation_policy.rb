# frozen_string_literal: true

module EntityResources
  class OrganisationPolicy
    include Pu::Policy::EntityResourcePolicy

    def permitted_attributes_for_read
      %i[id name headline description website_url
         company_type company_size industry country joel_test
         created_at updated_at]
    end

    def permitted_attributes_for_create
      %i[entity_id name headline description website_url
         company_type company_size industry country joel_test]
    end

    def permitted_attributes_for_update
      permitted_attributes_for_create
    end

    def permitted_associations
      [JobDescription]
    end

    class Scope
      include Pu::Policy::Initializer

      def resolve
        @context.parent.organisations.includes(:entity)
      end
    end
  end
end

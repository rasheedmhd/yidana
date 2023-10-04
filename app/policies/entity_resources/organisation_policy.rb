# frozen_string_literal: true

module EntityResources
  class OrganisationPolicy
    include Concerns::ResourcePolicy

    def permitted_attributes_for_read
      %i[id name headline description website_url
         company_type company_size industry country joel_test
         created_at updated_at]
    end

    def permitted_attributes_for_create
      %i[name headline description website_url
         company_type company_size industry country joel_test]
    end

    def permitted_attributes_for_update
      permitted_attributes_for_create
    end

    class Scope
      include Concerns::ResourcePolicyInitializer

      def resolve
        @context.parent.organisations
      end
    end
  end
end

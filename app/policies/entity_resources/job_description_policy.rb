# frozen_string_literal: true

module EntityResources
  class JobDescriptionPolicy
    include Concerns::ResourcePolicy

    def permitted_attributes_for_index
      %i[organisation title job_role experience_level job_type minimum_annual_salary
         created_at updated_at]
    end

    def permitted_attributes_for_show
      %i[organisation title description job_role experience_level job_type minimum_annual_salary maximum_annual_salary
         technologies offers_equity visa_sponsorship relocation_assistance created_at updated_at]
    end

    def permitted_attributes_for_create
      %i[organisation_id title description job_role experience_level job_type minimum_annual_salary maximum_annual_salary
         technologies offers_equity visa_sponsorship relocation_assistance ]
    end

    def permitted_attributes_for_update
      permitted_attributes_for_create
    end

    class Scope
      include Concerns::ResourcePolicyInitializer

      def resolve
        @context.parent.job_descriptions
      end
    end
  end
end

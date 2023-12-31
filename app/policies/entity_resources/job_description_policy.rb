# frozen_string_literal: true

module EntityResources
  class JobDescriptionPolicy
    include Pu::Policy::EntityResourcePolicy

    def permitted_attributes_for_read
      %i[id house title description job_role experience_level job_type
         minimum_annual_salary maximum_annual_salary technologies
         offers_equity visa_sponsorship relocation_assistance
         created_at updated_at]
    end

    def permitted_attributes_for_create
      %i[house_id title description job_role experience_level job_type
         minimum_annual_salary maximum_annual_salary technologies
         offers_equity visa_sponsorship relocation_assistance]
    end

    def permitted_attributes_for_update
      permitted_attributes_for_create
    end

    class Scope
      include Pu::Policy::Initializer

      def resolve
        @context.parent.job_descriptions.includes(:entity)
      end
    end
  end
end

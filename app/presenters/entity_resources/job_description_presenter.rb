# frozen_string_literal: true

module EntityResources
  class JobDescriptionPresenter < Presenter
    def build_table(permitted_attributes)
      columns = permitted_attributes & table_columns
      table = Pu::Builders::Table.new(JobDescription)
                                 .with_columns(columns)
                                 .with_record_actions(actions.only!(:show, :edit, :destroy))
                                 .with_toolbar_actions(actions.only!(:create))

      # define custom transformations
      %i[job_type job_role experience_level technologies].each do |name|
        table.define_column(name, display_helper: :display_name_of)
      end

      table
    end

    def build_form(permitted_attributes)
      inputs = permitted_attributes & form_inputs
      Pu::Builders::Form.new(JobDescription)
                        .with_inputs(inputs)
                        .define_input(:description, type: :quill)
                        .define_input(:organisation_id, collection: organisations_selection)
                        .define_input(:job_type, collection: JobType.collection, as: :radio_buttons)
                        .define_input(:job_role, collection: JobRole.collection)
                        .define_input(:experience_level, collection: ExperienceLevel.collection)
                        .define_input(:technologies, collection: Technology.collection)
    end

    def build_details(permitted_attributes)
      fields = permitted_attributes & detail_fields
      details = Pu::Builders::Details.new(JobDescription)
                                     .with_fields(fields)
                                     .with_actions(actions.except!(:create, :show))
                                     .define_field(:description, display_helper: :display_clamped_quill)

      # define custom transformations
      %i[job_type job_role experience_level technologies].each do |name|
        details.define_field(name, display_helper: :display_name_of)
      end

      details
    end

    def build_associations(_permitted_associations)
      Pu::Builders::Associations.new
    end

    private

    def table_columns
      %i[organisation title job_role experience_level job_type
         created_at updated_at]
    end

    def form_inputs
      %i[organisation_id title description job_role experience_level job_type
         minimum_annual_salary maximum_annual_salary technologies
         offers_equity visa_sponsorship relocation_assistance]
    end

    def detail_fields
      %i[organisation title description job_role experience_level job_type
         minimum_annual_salary maximum_annual_salary technologies
         offers_equity visa_sponsorship relocation_assistance
         created_at updated_at]
    end

    def associations_list
      []
    end

    def actions
      Pu::Builders::Actions.new.with_standard_actions
    end
  end
end

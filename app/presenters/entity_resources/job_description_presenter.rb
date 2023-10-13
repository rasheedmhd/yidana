# frozen_string_literal: true

module EntityResources
  class JobDescriptionPresenter < Presenter
    def build_collection(permitted_attributes)
      fields = permitted_attributes & collection_fields

      customize_fields(Pu::UI::Builder::Collection.new(JobDescription))
        .with_record_actions(actions.only!(:show, :edit, :destroy))
        .with_actions(actions.only!(:create))
        .with_fields(fields)
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

    def build_detail(permitted_attributes)
      fields = permitted_attributes & detail_fields

      customize_fields(Pu::UI::Builder::Detail.new(JobDescription))
        .with_actions(actions.except!(:create, :show))
        .with_fields(fields)
    end

    def build_associations(_permitted_associations)
      Pu::Builders::Associations.new
    end

    private

    def collection_fields
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

    def customize_fields(builder)
      %i[job_type job_role].each do |name|
        builder.define_field(Pu::UI::Field.new(name, display_helper: :display_name_of))
      end

      %i[experience_level technologies].each do |name|
        builder.define_field(Pu::UI::Field.new(name, display_helper: :display_name_of, options: { stack: true }))
      end

      builder.define_field(Pu::UI::Field.new(:description, display_helper: :display_clamped_quill))
      builder.define_field(Pu::UI::Field.new(:description, display_helper: :display_clamped_quill))

      builder
    end
  end
end

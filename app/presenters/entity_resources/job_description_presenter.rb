# frozen_string_literal: true

module EntityResources
  class JobDescriptionPresenter < Presenter
    def build_collection(permitted_attributes)
      fields = permitted_attributes & collection_fields

      customize_fields(Pu::UI::Builder::Collection.new(JobDescription))
        .with_record_actions(build_actions.only!(:show, :edit, :destroy))
        .with_actions(build_actions.only!(:create))
        .with_fields(fields)
    end

    def build_form(permitted_attributes)
      inputs = permitted_attributes & form_inputs

      customize_inputs(Pu::UI::Builder::Form.new(JobDescription))
        .with_inputs(inputs)
    end

    def build_detail(permitted_attributes)
      fields = permitted_attributes & detail_fields

      customize_fields(Pu::UI::Builder::Detail.new(JobDescription))
        .with_actions(build_actions.except!(:create, :show))
        .with_fields(fields)
    end

    def build_associations(_permitted_associations)
      Pu::Builders::Associations.new
    end

    def build_actions
      Pu::UI::Builder::Actions.new.with_standard_actions
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

    def customize_fields(builder)
      %i[job_type job_role].each do |name|
        builder.define_field(Pu::UI::Field.new(name, helper: :display_name_of))
      end

      %i[experience_level technologies].each do |name|
        builder.define_field(Pu::UI::Field.new(name, helper: :display_name_of, stack: true))
      end

      builder.define_field(Pu::UI::Field.new(:description, helper: :display_clamped_quill))
    end

    def customize_inputs(builder)
      builder
        .define_input(Pu::UI::Input.build(:description, type: :quill))
        .define_input(Pu::UI::Input.build(:minimum_annual_salary, type: :money))
        .define_input(Pu::UI::Input.build(:maximum_annual_salary, type: :money))
        .define_input(Pu::UI::Input.new(:job_type, collection: JobType.collection, as: :radio_buttons))
        .define_input(Pu::UI::Input.for_attribute(JobDescription, :job_role, collection: JobRole.collection))
        .define_input(Pu::UI::Input.for_attribute(JobDescription, :technologies, collection: Technology.collection))
        .define_input(Pu::UI::Input.for_attribute(JobDescription, :organisation_id,
                                                  collection: organisations_selection))
        .define_input(Pu::UI::Input.for_attribute(JobDescription, :experience_level,
                                                  collection: ExperienceLevel.collection))
    end
  end
end

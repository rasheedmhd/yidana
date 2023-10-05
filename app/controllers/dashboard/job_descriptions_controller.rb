# frozen_string_literal: true

module Dashboard
  class JobDescriptionsController < BaseController
    controller_for JobDescription, :title_cont

    # def build_table
    #   table = Pu::Builders::Table.new(resource_class)
    #                              .with_columns(permitted_attributes)

    #   # define custom transformations
    #   %i[organisation job_type job_role experience_level technologies].each do |name|
    #     table.define_column(name, display_helper: :display_name_of)
    #   end
    #   table
    # end

    # def build_details
    #   details = Pu::Builders::Details.new(resource_class)
    #                                  .with_fields(permitted_attributes)
    #                                  .define_field(:description, display_helper: :display_clamped_quill)

    #   # define custom transformations
    #   %i[organisation job_type job_role experience_level technologies].each do |name|
    #     details.define_field(name, display_helper: :display_name_of)
    #   end
    #   details
    # end

    # def build_form
    #   Pu::Builders::Form.new(resource_class)
    #                     .define_input(:description, type: :quill)
    #                     .define_input(:organisation_id, collection: current_entity.organisations.all)
    #                     .define_input(:job_type, collection: JobType.collection, as: :radio_buttons)
    #                     .define_input(:job_role, collection: JobRole.collection)
    #                     .define_input(:experience_level, collection: ExperienceLevel.collection)
    #                     .define_input(:technologies, collection: Technology.collection)
    #                     .with_inputs(permitted_attributes)
    # end

    # def build_actions
    #   Pu::Builders::Actions.new.with_standard_actions
    # end
  end
end

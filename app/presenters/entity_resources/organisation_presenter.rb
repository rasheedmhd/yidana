# frozen_string_literal: true

module EntityResources
  class OrganisationPresenter
    def initialize; end

    def build_table(permitted_attributes)
      columns = permitted_attributes & table_columns
      table = Pu::Builders::Table.new(Organisation)
                                 .with_columns(columns)
                                 .with_record_actions(build_actions.only!(:show, :edit, :destroy))
                                 .with_toolbar_actions(build_actions.only!(:create))

      # define custom transformations
      %i[industry company_size company_type joel_test country].each do |name|
        table.define_column(name, display_helper: :display_name_of)
      end

      table
    end

    def build_form(permitted_attributes)
      inputs = permitted_attributes & form_inputs
      Pu::Builders::Form.new(Organisation)
                        .with_inputs(inputs)
                        .define_input(:description, type: :quill)
                        .define_input(:company_type, collection: CompanyType.collection, as: :radio_buttons)
                        .define_input(:company_size, collection: CompanySize.collection, as: :radio_buttons)
                        .define_input(:industry, collection: Industry.collection)
                        .define_input(:country, collection: Country.collection)
                        .define_input(:joel_test, collection: JoelTest.collection, as: :check_boxes)
    end

    def build_details(permitted_attributes)
      fields = permitted_attributes & detail_fields
      details = Pu::Builders::Details.new(Organisation)
                                     .with_fields(fields)
                                     .with_actions(build_actions.except!(:create, :show))
                                     .define_field(:description, display_helper: :display_clamped_quill)
                                     .define_field(:joel_test, display_helper: :joel_test_details, options: { stack: false })

      # define custom transformations
      %i[industry company_size company_type country].each do |name|
        details.define_field(name, display_helper: :display_name_of)
      end

      details
    end

    def build_actions
      Pu::Builders::Actions.new.with_standard_actions
    end

    private

    def table_columns
      %i[name headline country created_at updated_at]
    end

    def form_inputs
      %i[name headline description website_url company_type company_size industry country joel_test]
    end

    def detail_fields
      %i[name headline description website_url company_type company_size industry country joel_test
         created_at updated_at]
    end
  end
end

# frozen_string_literal: true

module EntityResources
  class OrganisationPresenter < Presenter
    def build_collection(permitted_attributes)
      fields = permitted_attributes & collection_fields

      customize_fields(Pu::UI::Builder::Collection.new(Organisation))
        .with_record_actions(actions.only!(:show, :edit, :destroy))
        .with_actions(actions.only!(:create))
        .with_fields(fields)
    end

    def build_detail(permitted_attributes)
      fields = permitted_attributes & detail_fields

      customize_fields(Pu::UI::Builder::Detail.new(Organisation))
        .with_actions(actions.except!(:create, :show))
        .with_fields(fields)
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

    def build_associations(permitted_associations)
      associations = associations_list & permitted_associations
      Pu::Builders::Associations.new
                                .with_associations(associations)
    end

    private

    def collection_fields
      %i[name headline country created_at updated_at]
    end

    def detail_fields
      %i[name headline description website_url company_type company_size industry country joel_test
         created_at updated_at]
    end

    def form_inputs
      %i[entity_id name headline description website_url company_type company_size industry country joel_test]
    end

    def associations_list
      [JobDescription]
    end

    def actions
      Pu::Builders::Actions.new.with_standard_actions
    end

    def customize_fields(builder)
      %i[industry company_size company_type country].each do |name|
        builder.define_field(Pu::UI::Field.new(name, display_helper: :display_name_of))
      end

      builder.define_field(Pu::UI::Field.new(:description, display_helper: :display_clamped_quill))
      builder.define_field(Pu::UI::Field.new(:joel_test, display_helper: :joel_test_details, options: { stack: false }))

      builder
    end
  end
end

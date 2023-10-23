# frozen_string_literal: true

module EntityResources
  class OrganisationPresenter < Presenter
    def build_collection(permitted_attributes)
      fields = permitted_attributes & collection_fields

      customize_fields(Pu::UI::Builder::Collection.new(Organisation))
        .with_record_actions(build_actions.only!(:show, :edit, :destroy))
        .with_actions(build_actions.only!(:create))
        .with_fields(fields)
    end

    def build_detail(permitted_attributes)
      fields = permitted_attributes & detail_fields

      customize_fields(Pu::UI::Builder::Detail.new(Organisation))
        .with_actions(build_actions.except!(:create, :show))
        .with_fields(fields)
    end

    def build_form(permitted_attributes)
      inputs = permitted_attributes & form_inputs

      customize_inputs(Pu::UI::Builder::Form.new(Organisation))
        .with_inputs(inputs)
    end

    def build_associations(permitted_associations)
      associations = associations_list & permitted_associations
      Pu::Builders::Associations.new
                                .with_associations(associations)
    end

    def build_actions
      Pu::UI::Builder::Actions.new
                              .define_action(
                                Pu::UI::Action::InteractiveAction
                                .new(
                                  :simple_action,
                                  button: Pu::UI::Button.new(
                                    icon: 'border', label: 'Simple', button_class: 'primary'
                                  ),
                                  route: { method: :post }
                                )
                                .with_interaction(Organisations::SimpleAction)
                              )
                              .define_action(
                                Pu::UI::Action::InteractiveAction
                                .new(
                                  :advanced_action,
                                  button: Pu::UI::Button.new(
                                    icon: 'border-all', label: 'Advanced', button_class: 'primary'
                                  )
                                )
                                .with_interaction(Organisations::AdvancedAction)
                              )
                              .with_actions(:simple_action, :advanced_action)
                              .with_standard_actions
    end

    private

    def collection_fields
      %i[name headline country created_at updated_at]
    end

    def detail_fields
      %i[logo name headline description website_url company_type company_size industry country joel_test docs
         created_at updated_at]
    end

    def form_inputs
      %i[entity_id logo name headline description website_url company_type company_size industry country joel_test docs]
    end

    def associations_list
      [JobDescription]
    end

    def customize_fields(builder)
      %i[industry company_size company_type country].each do |name|
        builder.define_field(Pu::UI::Field.new(name, helper: :display_name_of))
      end

      builder
        .define_field(Pu::UI::Field.new(:description, helper: :display_clamped_quill))
        .define_field(Pu::UI::Field.new(:joel_test, helper: :joel_test_details, stack_multiple: false))
    end

    def customize_inputs(builder)
      builder
        .define_input(Pu::UI::Input.build(:description, type: :quill))
        .define_input(Pu::UI::Input.new(:joel_test, collection: JoelTest.collection, as: :check_boxes))
        .define_input(Pu::UI::Input.new(:company_type, collection: CompanyType.collection, as: :radio_buttons))
        .define_input(Pu::UI::Input.new(:company_size, collection: CompanySize.collection, as: :radio_buttons))
        .define_input(Pu::UI::Input.for_attribute(Organisation, :industry, collection: Industry.collection))
        .define_input(Pu::UI::Input.for_attribute(Organisation, :country, collection: Country.collection))
    end
  end
end

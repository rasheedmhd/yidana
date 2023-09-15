# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    def index
      pagy, organisations = pagy(Organisation.all)
      @table = build_table
               .with_records(organisations)
               .with_pagination(pagy)
    end

    def show
      @organisation = Organisation.find params.require(:id)
    end

    def new
      @organisation = Organisation.new
      @form = build_form.with_record(@organisation)
    end

    def create
      @organisation = Organisation.new(entity: current_entity, **params.require(:organisation).permit!)

      if @organisation.save
        redirect_to @organisation, notice: 'Organisation was successfully created.'
      else
        @form = build_form.with_record(@organisation)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @organisation = Organisation.find params.require(:id)
      @form = build_form.with_record(@organisation)
    end

    def update
      @organisation = Organisation.find params.require(:id)

      if @organisation.update(params.require(:organisation).permit!)
        redirect_to @organisation, notice: 'Organisation was successfully updated.', status: :see_other
      else
        @form = build_form.with_record(@organisation)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      organisation = Organisation.find params.require(:id)
      organisation.destroy

      redirect_to organisations_url, notice: 'Organisation was successfully deleted.', status: :see_other
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to organisation, alert: 'Organisation cannot be deleted.'
    end

    private

    def build_table
      table = Pu::Builders::Table.new(Organisation)
                                 .with_columns(:name, :headline, :company_type, :company_size, :country)

      # define custom transformations
      %i[industry company_size company_type joel_test country].each do |name|
        table.define_column(
          name,
          transformer: lambda { |value|
                         helpers.display_name_of value
                       }
        )
      end

      table
    end

    def build_form
      Pu::Builders::Form.new(Organisation)
                        .define_input(:company_type, collection: CompanyType.collection, as: :radio_buttons)
                        .define_input(:company_size, collection: CompanySize.collection, as: :radio_buttons)
                        .define_input(:industry, collection: Industry.collection)
                        .define_input(:country, collection: Country.collection)
                        .define_input(:joel_test, collection: JoelTest.collection, as: :check_boxes)
                        .with_inputs(:name, :headline, :description, :website_url, :company_type, :company_size, :industry, :country, :joel_test)
    end
  end
end

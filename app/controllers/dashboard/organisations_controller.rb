# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    def index
      @pagy, @organisations = pagy(Organisation.all)
      @table_builder = Pu::Table::Builder.new(Organisation)
                                         .with_records(@organisations)
                                         .with_pagination(@pagy)
                                         .with_columns(Organisation.columns.map(&:name))
      customize_table
    end

    def show
      @organisation = Organisation.find params.require(:id)
    end

    def new
      @organisation = Organisation.new
    end

    def edit
      @organisation = Organisation.find params.require(:id)
    end

    def create
      @organisation = Organisation.new(entity: current_entity, **params.require(:organisation).permit!)

      if @organisation.save
        redirect_to @organisation, notice: 'Organisation was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @organisation = Organisation.find params.require(:id)

      if @organisation.update(params.require(:organisation).permit!)
        redirect_to @organisation, notice: 'Organisation was successfully updated.', status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @organisation = Organisation.find params.require(:id)
      @organisation.destroy

      redirect_to organisations_url, notice: 'Organisation was successfully deleted.', status: :see_other
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to @organisation, alert: 'Organisation cannot be deleted.'
    end

    private

    def customize_table
      @table_builder.except_columns :id, :entity_id

      %i[industry company_size company_type joel_test country].each do |name|
        @table_builder.with_column(
          name,
          transformer: lambda { |value|
                         helpers.display_name_of value
                       }
        )
      end
    end
  end
end

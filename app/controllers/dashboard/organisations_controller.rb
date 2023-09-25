# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    before_action :set_organisation, only: %i[show edit update destroy]

    # GET /organisations(.{format})
    def index
      authorize Organisation

      @q = policy_scope(Organisation).ransack(params[:q])
      @pagy, @organisations = pagy @q.result
      @table = build_table
               .with_records(@organisations)
               .with_pagination(@pagy)
               .with_record_actions(build_actions.only!(:show, :edit, :destroy))
               .with_toolbar_actions(build_actions.only!(:create))
               .search_with(@q, :name_cont)
    end

    # GET /organisations/1(.{format})
    def show
      authorize @organisation
    end

    # GET /organisations/new
    def new
      authorize Organisation

      @organisation = Organisation.new
      @form = build_form.with_record(@organisation)
    end

    # GET /organisations/1/edit
    def edit
      authorize @organisation

      @form = build_form.with_record(@organisation)
    end

    # POST /organisations(.{format})
    def create
      authorize Organisation

      respond_to do |format|
        @organisation = Organisation.new(entity: current_entity, **params.require(:organisation).permit!)

        if @organisation.save
          format.html do
            redirect_to adapt_route_args(@organisation), notice: 'Organisation was successfully created.'
          end
          format.any { render :show, status: :created, location: @organisation }
        else
          format.html do
            @form = build_form.with_record(@organisation)
            render :new, status: :unprocessable_entity
          end
          format.any do
            @errors = @organisation.errors
            render 'errors', status: :unprocessable_entity
          end
        end
      end
    end

    # PATCH/PUT /organisations/1(.{format})
    def update
      authorize @organisation

      respond_to do |format|
        if @organisation.update(params.require(:organisation).permit!)
          format.html do
            redirect_to adapt_route_args(@organisation), notice: 'Organisation was successfully updated.',
                                                         status: :see_other
          end
          format.any { render :show, status: :ok, location: adapt_route_args(@organisation) }
        else
          format.html do
            @form = build_form.with_record(@organisation)
            render :edit, status: :unprocessable_entity
          end
          format.any do
            @errors = @organisation.errors
            render 'errors', status: :unprocessable_entity
          end
        end
      end
    end

    # DELETE /organisations/1(.{format})
    def destroy
      authorize @organisation

      respond_to do |format|
        @organisation.destroy

        format.html { redirect_to adapt_route_args(Organisation), notice: 'Organisation was successfully deleted.' }
        format.json { head :no_content }
      rescue ActiveRecord::InvalidForeignKey => e
        format.html do
          redirect_to adapt_route_args(@organisation), alert: 'Organisation is referenced by other records.'
        end
        format.any do
          @errors = ActiveModel::Errors.new @organisation
          @errors.add :base, :existing_references, message: 'is referenced by other records'

          render 'errors', status: :unprocessable_entity
        end
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def organisation_params
      params.require(:organisation).permit(@permitted_attributes)
    end

    def set_organisation
      @organisation = policy_scope(Organisation).find params.require(:id)
    end

    def build_table
      table = Pu::Builders::Table.new(Organisation)
                                 .with_columns(@permitted_attributes)

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
                        .define_input(:description, type: :quill)
                        .define_input(:company_type, collection: CompanyType.collection, as: :radio_buttons)
                        .define_input(:company_size, collection: CompanySize.collection, as: :radio_buttons)
                        .define_input(:industry, collection: Industry.collection)
                        .define_input(:country, collection: Country.collection)
                        .define_input(:joel_test, collection: JoelTest.collection, as: :check_boxes)
                        .with_inputs(@permitted_attributes)
    end

    def build_actions
      Pu::Builders::Actions.new.with_standard_actions
    end
  end
end

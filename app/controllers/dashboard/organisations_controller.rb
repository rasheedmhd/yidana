# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    before_action :set_organisation, only: %i[show edit update destroy]

    # GET /organisations or /organisations.json
    def index
      authorize Organisation

      @q = policy_scope(Organisation).ransack(params[:q])
      @pagy, @organisations = pagy @q.result
      @table = build_table
               .with_records(@organisations)
               .with_pagination(@pagy)
               .with_columns(policy(Organisation).permitted_attributes_for_index)

      # respond_to do |format|
      #   format.html
      #   format.json
      # end
    end

    # GET /organisations/1 or /organisations/1.json
    def show
      authorize @organisation
    end

    # GET /organisations/new
    def new
      authorize Organisation

      @organisation = Organisation.new
      @form = build_form
              .with_record(@organisation)
              .with_inputs(policy(Organisation).permitted_attributes_for_create)
    end

    # GET /organisations/1/edit
    def edit
      authorize @organisation

      @form = build_form
              .with_record(@organisation)
              .with_inputs(policy(Organisation).permitted_attributes_for_update)
    end

    # POST /organisations or /organisations.json
    def create
      authorize Organisation

      @organisation = Organisation.new(entity: current_entity, **params.require(:organisation).permit!)

      if @organisation.save
        redirect_to @organisation, notice: 'Organisation was successfully created.'
      else
        @form = build_form
                .with_record(@organisation)
                .with_inputs(policy(Organisation).permitted_attributes_for_create)
        render :new, status: :unprocessable_entity
      end

      # respond_to do |format|
      #   if @organisation.save
      #     format.html { redirect_to @organisation, notice: "Article was successfully created." }
      #     format.json { render :show, status: :created, location: @organisation }
      #     format.js
      #   else
      #     format.html { render :new, status: :unprocessable_entity }
      #     format.json { render json: @organisation.errors, status: :unprocessable_entity }
      #   end
      # end
    end

    # PATCH/PUT /organisations/1 or /organisations/1.json
    def update
      authorize @organisation

      if @organisation.update(params.require(:organisation).permit!)
        redirect_to @organisation, notice: 'Organisation was successfully updated.', status: :see_other
      else
        @form = build_form
                .with_record(@organisation)
                .with_inputs(policy(Organisation).permitted_attributes_for_update)
        render :edit, status: :unprocessable_entity
      end

      # if @organisation.update(organisation_params)
      #   format.html { redirect_to @organisation, notice: "Article was successfully updated." }
      #   format.json { render :show, status: :ok, location: @organisation }
      #   format.js
      # else
      #   format.html { render :edit, status: :unprocessable_entity }
      #   format.json { render json: @organisation.errors, status: :unprocessable_entity }
      # end
    end

    # DELETE /organisations/1 or /organisations/1.json
    def destroy
      authorize @organisation

      @organisation.destroy
      respond_to do |format|
        format.html { redirect_to organisations_url, notice: 'Article was successfully destroyed.' }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to(organisation, alert: 'Organisation cannot be deleted.') and return
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
  end
end

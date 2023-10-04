# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    before_action :set_organisation, only: %i[show edit update destroy]

    controller_for Organisation

    # GET /organisations(.{format})
    def index
      authorize Organisation

      @q = policy_scope(Organisation).ransack(params[:q])
      @pagy, @organisations = pagy @q.result
      @table = build_table
               .with_records(@organisations)
               .with_pagination(@pagy)
               .search_with(@q, :name_cont)
    end

    # GET /organisations/1(.{format})
    def show
      authorize @organisation

      @details = build_details.with_record(@organisation)
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
        @organisation = Organisation.new(organisation_params)
        @organisation.entity = current_entity

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
        if @organisation.update(organisation_params)
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

    def organisation_params
      # we don't care much about strong parameters since we have our own whitelist
      params.require(:organisation).permit!.slice(*@permitted_attributes)
    end

    def set_organisation
      @organisation = policy_scope(Organisation).where(slug: params.require(:id)).first!
    end

    def build_table
      EntityResources::OrganisationPresenter.new.build_table(@permitted_attributes)
    end

    def build_details
      EntityResources::OrganisationPresenter.new.build_details(@permitted_attributes)
    end

    def build_form
      EntityResources::OrganisationPresenter.new.build_form(@permitted_attributes)
    end

    def build_actions
      EntityResources::OrganisationPresenter.new.build_actions
    end
  end
end

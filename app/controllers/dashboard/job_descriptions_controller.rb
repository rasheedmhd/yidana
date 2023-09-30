# frozen_string_literal: true

module Dashboard
  class JobDescriptionsController < BaseController
    before_action :set_job_description, only: %i[show edit update destroy]

    controller_for JobDescription

    # GET /job_descriptions(.{format})
    def index
      authorize resource_class

      @q = policy_scope(resource_class).ransack(params[:q])
      @pagy, @job_descriptions = pagy @q.result
      @table = build_table
               .with_records(@job_descriptions)
               .with_pagination(@pagy)
               .with_record_actions(build_actions.only!(:show, :edit, :destroy))
               .with_toolbar_actions(build_actions.only!(:create))
               .search_with(@q, :title_cont)
    end

    # GET /job_descriptions/1(.{format})
    def show
      authorize @job_description

      @details = build_details
                 .with_record(@job_description)
                 .with_actions(build_actions.except!(:create, :show))
    end

    # GET /job_descriptions/new
    def new
      authorize resource_class

      @job_description = JobDescription.new
      @form = build_form.with_record(@job_description)
    end

    # GET /job_descriptions/1/edit
    def edit
      authorize @job_description

      @form = build_form.with_record(@job_description)
    end

    # POST /job_descriptions(.{format})
    def create
      authorize resource_class

      respond_to do |format|
        @job_description = JobDescription.new(entity: current_entity, **params.require(:job_description).permit!)

        if @job_description.save
          format.html do
            redirect_to adapt_route_args(@job_description), notice: 'JobDescription was successfully created.'
          end
          format.any { render :show, status: :created, location: @job_description }
        else
          format.html do
            @form = build_form.with_record(@job_description)
            render :new, status: :unprocessable_entity
          end
          format.any do
            @errors = @job_description.errors
            render 'errors', status: :unprocessable_entity
          end
        end
      end
    end

    # PATCH/PUT /job_descriptions/1(.{format})
    def update
      authorize @job_description

      respond_to do |format|
        if @job_description.update(params.require(:job_description).permit!)
          format.html do
            redirect_to adapt_route_args(@job_description), notice: 'JobDescription was successfully updated.',
                                                            status: :see_other
          end
          format.any { render :show, status: :ok, location: adapt_route_args(@job_description) }
        else
          format.html do
            @form = build_form.with_record(@job_description)
            render :edit, status: :unprocessable_entity
          end
          format.any do
            @errors = @job_description.errors
            render 'errors', status: :unprocessable_entity
          end
        end
      end
    end

    # DELETE /job_descriptions/1(.{format})
    def destroy
      authorize @job_description

      respond_to do |format|
        @job_description.destroy

        format.html { redirect_to adapt_route_args(JobDescription), notice: 'JobDescription was successfully deleted.' }
        format.json { head :no_content }
      rescue ActiveRecord::InvalidForeignKey => e
        format.html do
          redirect_to adapt_route_args(@job_description), alert: 'JobDescription is referenced by other records.'
        end
        format.any do
          @errors = ActiveModel::Errors.new @job_description
          @errors.add :base, :existing_references, message: 'is referenced by other records'

          render 'errors', status: :unprocessable_entity
        end
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def job_description_params
      params.require(:job_description).permit(@permitted_attributes)
    end

    def set_job_description
      @job_description = policy_scope(resource_class).find params.require(:id)
    end

    def build_table
      table = Pu::Builders::Table.new(resource_class)
                                 .with_columns(@permitted_attributes)

      # define custom transformations
      %i[organisation job_type job_role experience_level technologies].each do |name|
        table.define_column(name, display_helper: :display_name_of)
      end
      table
    end

    def build_details
      details = Pu::Builders::Details.new(resource_class)
                                     .with_fields(@permitted_attributes)
                                     .define_field(:description, display_helper: :display_clamped_quill)

      # define custom transformations
      %i[organisation job_type job_role experience_level technologies].each do |name|
        details.define_field(name, display_helper: :display_name_of)
      end
      details
    end

    def build_form
      Pu::Builders::Form.new(resource_class)
                        .define_input(:description, type: :quill)
                        .define_input(:organisation_id, collection: current_entity.organisations.all)
                        .define_input(:job_type, collection: JobType.collection, as: :radio_buttons)
                        .define_input(:job_role, collection: JobRole.collection)
                        .define_input(:experience_level, collection: ExperienceLevel.collection)
                        .define_input(:technologies, collection: Technology.collection)
                        .with_inputs(@permitted_attributes)
    end

    def build_actions
      Pu::Builders::Actions.new.with_standard_actions
    end
  end
end

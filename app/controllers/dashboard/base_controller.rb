# frozen_string_literal: true

module Dashboard
  class BaseController < ApplicationController
    include CurrentUser
    include CurrentEntity
    include CurrentParent
    include UrlPathRouteAdapter
    include Pundit::Authorization

    before_action :set_page_title
    before_action :set_sidebar_menu

    after_action :verify_authorized
    after_action :verify_policy_scoped, except: %i[new create]

    # https://github.com/ddnexus/pagy/blob/master/docs/extras/headers.md#headers
    after_action { pagy_headers_merge(@pagy) if @pagy }

    layout 'dashboard'

    # GET /resources(.{format})
    def index
      authorize resource_class

      q = policy_scope(resource_class).ransack(params[:q])
      pagy, @resource_records = pagy q.result
      @table = build_table
               .with_records(@resource_records)
               .with_pagination(pagy)
               .search_with(q, resource_search_field)
    end

    # GET /resources/1(.{format})
    def show
      authorize resource_record

      @record = resource_record
      @details = build_details.with_record(@record)
    end

    # GET /resources/new
    def new
      authorize resource_class

      @form = build_form.with_record(resource_class.new)
    end

    # GET /resources/1/edit
    def edit
      authorize resource_record

      @form = build_form.with_record(resource_record)
    end

    # POST /resources(.{format})
    def create
      authorize resource_class

      respond_to do |format|
        @record = resource_class.new(resource_params)

        if @record.save
          format.html do
            redirect_to adapt_route_args(@record),
                        notice: "#{helpers.resource_name(resource_class)} was successfully created."
          end
          format.any { render :show, status: :created, location: adapt_route_args(@record) }
        else
          format.html do
            @form = build_form.with_record(@record)
            render :new, status: :unprocessable_entity
          end
          format.any do
            @errors = @record.errors
            render 'errors', status: :unprocessable_entity
          end
        end
      end
    end

    # PATCH/PUT /organisations/1(.{format})
    def update
      authorize resource_record

      respond_to do |format|
        @record = resource_record

        if @record.update(resource_params)
          format.html do
            redirect_to adapt_route_args(@record), notice: "#{helpers.resource_name(resource_class)} was successfully updated.",
                                                   status: :see_other
          end
          format.any { render :show, status: :ok, location: adapt_route_args(@record) }
        else
          format.html do
            @form = build_form.with_record(@record)
            render :edit, status: :unprocessable_entity
          end
          format.any do
            @errors = @record.errors
            render 'errors', status: :unprocessable_entity
          end
        end
      end
    end

    # DELETE /organisations/1(.{format})
    def destroy
      authorize resource_record

      respond_to do |format|
        resource_record.destroy

        format.html do
          redirect_to adapt_route_args(resource_class),
                      notice: "#{helpers.resource_name(resource_class)} was successfully deleted."
        end
        format.json { head :no_content }
      rescue ActiveRecord::InvalidForeignKey => e
        format.html do
          redirect_to adapt_route_args(resource_record),
                      alert: "#{helpers.resource_name(resource_class)} is referenced by other records."
        end
        format.any do
          @errors = ActiveModel::Errors.new resource_record
          @errors.add :base, :existing_references, message: 'is referenced by other records'

          render 'errors', status: :unprocessable_entity
        end
      end
    end

    private

    # Resource
    class << self
      attr_reader :resource_class, :resource_search_field

      def controller_for(resource_class, resource_search_field)
        @resource_class = resource_class
        @search_field = resource_search_field
      end
    end

    def resource_class
      self.class.resource_class
    end
    helper_method :resource_class

    def resource_search_field
      self.class.resource_search_field
    end

    def resource_record
      return unless params[:id].present?

      @resource_record = policy_scope(resource_class).from_path_param(params[:id]).first!
    end
    # helper_method :resource_record

    def resource_params
      # we don't care much about strong parameters since we have our own whitelist
      # strong params and pundit permitted_attributes don't support array/hash params without a convoluted
      # attribute list
      form_params = params.require(resource_param_key).permit!.slice(*permitted_attributes)

      # ensure that we override params with values set from the url
      if respond_to?(:current_entity, true) && current_entity.present? && resource_class.columns_hash.key?('entity_id')
        form_params[:entity_id] = current_entity.id
      end

      form_params[parent_param_key] = current_parent.id if respond_to?(:current_parent, true) && current_parent.present?

      form_params
    end

    def resource_param_key
      resource_class.to_s.underscore
    end

    # Presentation

    def resource_presenter
      @resource_presenter ||= "EntityResources::#{resource_class}Presenter".constantize
      @resource_presenter.new
    end

    def build_table
      resource_presenter.build_table(permitted_attributes)
    end

    def build_details
      resource_presenter.build_details(permitted_attributes)
    end

    def build_form
      resource_presenter.build_form(permitted_attributes)
    end

    def build_actions
      resource_presenter.new.build_actions
    end

    # Layout

    def set_page_title
      @page_title = 'Dashboard'
    end

    def set_sidebar_menu
      @sidebar_menu = {
        dashboard: {
          home: entity_path(current_entity),
          organisations: entity_organisations_path(current_entity),
          job_descriptions: entity_job_descriptions_path(current_entity)
        },
        separated: {
          settings: ''
        }
      }
    end

    # Authorisation

    def permitted_attributes(policy_subject = nil)
      policy_subject ||= resource_record || resource_class
      @permitted_attributes ||= current_policy.send "permitted_attributes_for_#{action_name}".to_sym
    end
    helper_method :permitted_attributes

    def current_policy
      policy_subject = resource_record || resource_class
      policy(policy_subject)
    end

    def policy(scope)
      super([:entity_resources, scope])
    end

    def policy_scope(scope)
      super([:entity_resources, scope])
    end

    def authorize(record, query = nil)
      super([:entity_resources, record], query)
    end

    def pundit_user
      EntityResources::PolicyContext.new user: current_user, entity: current_entity, parent: current_parent
    end
  end
end

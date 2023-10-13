# frozen_string_literal: true

module EntityResources
  class ResourceController < ::ResourceController
    include Concerns::CurrentEntity
    include Concerns::CurrentParent
    include Concerns::RouteArgsAdapter

    private

    # Resource

    def resource_params
      form_params = super

      # ensure that we override params with values set from the path
      if current_entity.present? && resource_class.columns_hash.key?('entity_id')
        form_params[:entity_id] = current_entity.id
      end

      form_params
    end

    # Presentation

    def resource_presenter(resource_class)
      entity_resource_presenter = "EntityResources::#{resource_class.to_s.classify}Presenter".constantize
      entity_resource_presenter.new resource_context
    end

    def build_form
      form = super
      form.except!(:entity_id) if current_entity.present?

      form
    end

    # Layout

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
      resource_context
    end

    def resource_context
      @resource_context ||= Pu::ResourceContext.new(
        user: current_user,
        entity: current_entity,
        parent: current_parent
      )
    end
  end
end

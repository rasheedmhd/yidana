# frozen_string_literal: true

module Dashboard
  class BaseController < ApplicationController
    include Pundit::Authorization
    include CurrentEntity
    include UrlPathRouteAdapter

    before_action :set_page_title
    before_action :set_sidebar_menu
    before_action :set_permitted_attributes, except: %i[destroy]

    after_action :verify_authorized
    after_action :verify_policy_scoped, except: %i[new create]

    # https://github.com/ddnexus/pagy/blob/master/docs/extras/headers.md#headers
    after_action { pagy_headers_merge(@pagy) if @pagy }

    layout 'dashboard'

    private

    def set_page_title
      @page_title = 'Dashboard'
    end

    def set_sidebar_menu
      @sidebar_menu = {
        dashboard: {
          home: entity_path(current_entity),
          organisations: entity_organisations_path(current_entity)
        },
        separated: {
          settings: ''
        }
      }
    end

    def set_permitted_attributes
      @permitted_attributes ||= begin
        action = {
          new: :create,
          edit: :update
        }[action_name.to_sym] || action_name

        policy(Organisation).send "permitted_attributes_for_#{action}".to_sym
      end
    end

    def pundit_user
      EntityResources::PolicyContext.new current_entity, current_user
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
  end
end

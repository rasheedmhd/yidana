# frozen_string_literal: true

module Dashboard
  class BaseController < ApplicationController
    include CurrentEntity
    include EntityUrlHelpers

    before_action :set_page_title
    before_action :set_sidebar_menu

    layout 'dashboard'

    private

    def set_page_title
      @page_title = 'Dashboard'
    end

    def set_sidebar_menu
      @sidebar_menu = {
        dashboard: {
          home: entity_path(current_entity),
          organisations: entity_organisations_path(current_entity),
          users: entity_users_path(current_entity)
        },
        reports: {
          'All': edit_user_path(current_entity)
        },
        separated: {
          settings: ''
        }
      }
    end
  end
end

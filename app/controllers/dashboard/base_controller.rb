# frozen_string_literal: true

module Dashboard
  class BaseController < ApplicationController
    include CurrentEntity
    include EntityUrlHelpers

    layout 'dashboard'

    private

    def sidebar_menu
      {
        dashboard: {
          home: entity_path(current_entity),
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
    helper_method :sidebar_menu
  end
end

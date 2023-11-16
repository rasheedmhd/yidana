# frozen_string_literal: true

class DashboardController < ApplicationController
  include CurrentUser

  #
  # Redirects the logged in user to an entity specific dashboard
  #
  def index
    redirect_to entity_path(current_entity)
    # redirect_to current_user
  end

  #
  # Attempts to retrieve the last visited entity if it was set.
  # Else, it defaults to the user's first entity
  #
  # @see CurrentEntity@require_current_entity
  #
  def current_entity
    @current_entity ||= begin
      if session[:current_entity].present?
        # be lenient when retrieving from the session
        # the user might have lost access between when the session var was set and now
        current_entity = current_user.entities.where(id: session[:current_entity]).first
      end
      # default to their first entity if one isn't set
      current_entity = current_user.entities.first unless current_entity.present?
      current_entity
    end
  end
end

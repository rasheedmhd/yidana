# frozen_string_literal: true

module Dashboard
  class IndexController < DashboardController
    def index; end

    def switch_entity
      entity_id = params.require :entity_id
      current_entity = current_user.entities.where(id: entity_id).first

      head :unauthorized and return unless current_entity.present?

      session[:current_entity] = current_entity.id
      redirect_to action: :index
    end
  end
end

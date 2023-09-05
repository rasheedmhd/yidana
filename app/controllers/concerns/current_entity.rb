# frozen_string_literal: true

#
# Requires the current entity in the :require_current_entity before action
# Current entity is available via #current_entity
#
module CurrentEntity
  def self.included(base)
    base.send :helper_method, :current_entity
    base.send :before_action, :current_entity
    base.send :before_action, :require_current_entity

    base.send :include, CurrentUser
  end

  private

  def require_current_entity
    # redirect to onboardig page if current_entity is not set
    redirect_to(onboarding_path) and return unless current_entity.present?
  end

  def current_entity
    @current_entity ||= begin
      current_entity_id = session[:current_entity]
      current_entity = current_user.entities.where(id: current_entity_id).first if current_entity_id.present?
      current_entity = current_user.entities.first unless current_entity.present?
      session[:current_entity] = current_entity&.id
      current_entity
    end
  end
end
